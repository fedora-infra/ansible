#!/usr/bin/env python3

import argparse
import datetime as dt
import logging
import logging.handlers
import os
import re
import signal
import socket
import subprocess
import uuid
import yaml
from multiprocessing import Pool
from pathlib import Path
from tempfile import mktemp

from fedora_messaging import api, message


RSYNC_PROG = "/usr/bin/rsync"
RSYNC_FLAGS = "-avSHP --no-motd --timeout=1200 --contimeout=1200"
RSYNC_CMD = [RSYNC_PROG] + RSYNC_FLAGS.split()

RUN_ID = str(uuid.uuid4())
LOGHOST = socket.getfqdn()
MSGTOPIC_PREFIX = "logging.stats"

CONFIG_FILE = Path("/etc/sync-http-logs.yaml")
BASE_LOGDIR = Path("/var/log/hosts")
DAYS_TO_FETCH = 3
RETRY_ATTEMPTS = 3
PARALLEL_WORKERS = 5

log = logging.getLogger(__name__)


def send_bus_msg(topic, **kwargs):
    msg = message.Message(topic=f"{MSGTOPIC_PREFIX}.{topic}", body=kwargs)
    api.publish(msg)


def send_sync_msg(topic, **kwargs):
    kwargs.setdefault("host", LOGHOST)
    kwargs.setdefault("run_id", RUN_ID)
    send_bus_msg(topic, **kwargs)


def link_force_atomic(src, dst):
    """(Hard-)link src to dst atomically.

    As one can't create a link over an existing destination file, this
    function creates it as a temporary file in the same directory first and
    then renames it over the specified destination file.
    """
    dst = Path(dst)
    dstdir = dst.parent

    while True:
        tmpdst = mktemp(dir=dstdir)
        try:
            os.link(src, tmpdst)
        except FileExistsError:
            # ignore if the file exists, just try another file name
            pass
        else:
            # no exception: linking to temp file succeeded, rename it over dst
            os.rename(tmpdst, dst)

            # if tmpdst and dst are the same hard link, unlink tmpdst here because os.rename() would
            # have been a no-op
            try:
                os.unlink(tmpdst)
            except FileNotFoundError:
                # os.rename() above wasn't a no-op, i.e. tmpdst was renamed already
                pass

            break


def seed_dated_logfiles(date, srcdir, dstdir):
    date_tag = date.strftime("%Y%m%d")
    untagged_re = re.compile(r"^(?P<name>.*)log\.(?P<ext>[^\.]+)$")

    for srcfile in srcdir.glob("*log.*"):
        if srcfile.is_symlink() or not srcfile.is_file():
            continue
        match = untagged_re.match(srcfile.name)
        if not match:
            continue
        parts = match.groupdict()
        dstfile = dstdir / f"{parts['name']}log-{date_tag}.{parts['ext']}"
        link_force_atomic(srcfile, dstfile)


def link_back_undated_logfiles(date, srcdir, dstdir):
    date_tag = date.strftime("%Y%m%d")
    tagged_re = re.compile(rf"^(?P<name>.*)log-{date_tag}\.(?P<ext>[^\.]+)$")

    for srcfile in srcdir.glob("*log-*.*"):
        if srcfile.is_symlink() or not srcfile.is_file():
            continue
        match = tagged_re.match(srcfile.name)
        if not match:
            continue
        parts = match.groupdict()
        dstfile = dstdir / f"{parts['name']}log.{parts['ext']}"
        link_force_atomic(srcfile, dstfile)


def sync_http_logs(synced_host):
    # Skip hosts not known to DNS
    try:
        socket.gethostbyname(synced_host)
    except socket.gaierror as e:
        if e.errno == socket.EAI_NONAME:
            log.info("Skipping sync from unknown host %s.", synced_host)
            send_sync_msg("sync.host.skip", synced_host=synced_host, reason="Synced host unknown")
            return
        raise

    # log.info("Started sync from %s.", synced_host)
    send_sync_msg("sync.host.start", synced_host=synced_host)

    for days_in_past in range(1, DAYS_TO_FETCH + 1):
        date = dt.date.today() - dt.timedelta(days=days_in_past)
        date_str = date.strftime("%Y%m%d")
        year = str(date.year)
        month = f"{date.month:02d}"
        day = f"{date.day:02d}"
        log_date = f"{year}-{month}-{day}"
        target_dir_root = BASE_LOGDIR / synced_host / year / month / day
        target_dir_undated = target_dir_root / "http"
        target_dir_dated = target_dir_root / "http_with_date"

        send_sync_msg("sync.host.logdate.start", synced_host=synced_host, log_date=log_date)

        target_dir_undated.mkdir(parents=True, exist_ok=True)
        target_dir_dated.mkdir(exist_ok=True)

        # log.info(
        #     "log.info %s, log date %s, seeding dated logfiles from undated", synced_host, log_date
        # )
        seed_dated_logfiles(date, target_dir_undated, target_dir_dated)

        for attempt in range(1, RETRY_ATTEMPTS + 1):
            # log.info("... host %s, log date %s, attempt %d", synced_host, log_date, attempt)
            try:
                exitcode = subprocess.call(
                    RSYNC_CMD + [f"{synced_host}::log/httpd/*{date_str}*", str(target_dir_dated)],
                    stdout=subprocess.DEVNULL,
                    timeout=7200,
                )
            except subprocess.TimeoutExpired:
                reason = "Timeout expired."
            else:
                if exitcode:
                    reason = f"Error code: {exitcode}"
                else:
                    break
                if attempt > 0:
                    topic = "sync.host.logdate.fail.retry"
                else:
                    topic = "sync.host.logdate.fail.final"
                    log.info(
                        "rsync from %s failed for %s for the last time",
                        synced_host,
                        log_date,
                    )
                send_sync_msg(topic, synced_host=synced_host, log_date=log_date, reason=reason)

        # log.info(
        #     "... host %s, log date %s, linking back undated logfiles from dated",
        #     synced_host,
        #     log_date,
        # )
        link_back_undated_logfiles(date, target_dir_dated, target_dir_undated)

        send_sync_msg("sync.host.logdate.finish", synced_host=synced_host, log_date=log_date)

    # log.info(f"c{synced_host}.")
    send_sync_msg("sync.host.finish", synced_host=synced_host)


def parse_commandline_args():
    parser = argparse.ArgumentParser(description="sync http log files from various hosts")

    verbosity_group = parser.add_mutually_exclusive_group()
    verbosity_group.add_argument(
        "--verbosity", action="store", type=int, default=1, help="Set verbosity level"
    )
    verbosity_group.add_argument(
        "-v", "--verbose", action="count", dest="verbosity", help="Increase verbosity level"
    )
    verbosity_group.add_argument(
        "-s", "--silent", action="store_const", dest="verbosity", const=0, help="Silence output"
    )

    parser.add_argument("--syslog", action="store_true", default=False, help="Log to syslog")
    parser.add_argument("--syslog-verbosity", type=int)

    args = parser.parse_args()
    return args


def init_worker():
    signal.signal(signal.SIGINT, signal.SIG_IGN)


# main

# process command line arguments
args = parse_commandline_args()

VERBOSITY_TO_LOG_LEVEL = [logging.ERROR, logging.WARNING, logging.INFO, logging.DEBUG]
MAX_VERBOSITY = len(VERBOSITY_TO_LOG_LEVEL) - 1

verbosity = min(max(0, args.verbosity), MAX_VERBOSITY)
commandline_log_level = VERBOSITY_TO_LOG_LEVEL[verbosity]
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.DEBUG)
log.addHandler(console_handler)

if not args.syslog:
    log.setLevel(commandline_log_level)
else:
    syslog_verbosity = args.syslog_verbosity
    if syslog_verbosity is None:
        syslog_verbosity = commandline_log_level
    syslog_verbosity = min(max(0, syslog_verbosity), MAX_VERBOSITY)
    syslog_log_level = VERBOSITY_TO_LOG_LEVEL[syslog_verbosity]
    log.setLevel(min(commandline_log_level, syslog_log_level))
    syslog_handler = logging.handlers.SysLogHandler("/dev/log")
    syslog_handler.setLevel(syslog_log_level)
    syslog_formatter = logging.Formatter("%(module)s[%(levelname)s]: %(message)s")
    syslog_handler.setFormatter(syslog_formatter)
    log.addHandler(syslog_handler)

try:
    with open(CONFIG_FILE) as config_file:
        config = yaml.load(config_file)

    worker_pool = Pool(PARALLEL_WORKERS, initializer=init_worker)

    send_sync_msg("sync.start")
    log.info("=== START OF RUN ===")

    log.debug("Mapping synced hosts to pool workers.")
    try:
        worker_pool.map(sync_http_logs, config["synced_hosts"])
    except KeyboardInterrupt:
        log.warn("Interrupted!")
        worker_pool.terminate()

    send_sync_msg("sync.finish")
    log.info("=== FINISH OF RUN ===")
except Exception as e:
    if not isinstance(e, KeyboardInterrupt):
        log.exception("Something went wrong, caught an exception:")
