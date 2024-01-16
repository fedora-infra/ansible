#
# This is the config file for MirrorManager as intended to be used in OpenShift
#

OIDC_CLIENT_SECRETS = '/etc/mirrormanager/client_secrets.json'

# This is the directory the code enabled by SHOW_STATISTICS will use
# to locate the statistics files and display them.
STATISTICS_BASE = "/var/www/mirrormanager-statistics/data"

{% if env == 'staging' %}

# url to the database server:
DB_URL='postgresql://{{ mirrormanager_stg_db_user }}:{{ mirrormanager_stg_db_pass }}@{{ mirrormanager_db_host }}/{{ mirrormanager_stg_db_name }}'

# secret key used to generate unique csrf token
SECRET_KEY = '{{ mirrormanager_stg_secret_key }}'

# Seed used to make the password harder to brute force in case of leaking
# This should be kept really secret!
PASSWORD_SEED = "{{ mirrormanager_stg_password_seed }}"

{% else %}

# url to the database server:
DB_URL='postgresql://{{ mirrormanager_db_user }}:{{ mirrormanager_db_pass }}@{{ mirrormanager_db_host }}/{{ mirrormanager_db_name }}'

# secret key used to generate unique csrf token
SECRET_KEY = '{{ mirrormanager_secret_key }}'

# Seed used to make the password harder to brute force in case of leaking
# This should be kept really secret!
PASSWORD_SEED = "{{ mirrormanager_password_seed }}"

{% endif %}

ITEMS_PER_PAGE = 50
# Make browsers send session cookie only via HTTPS
SESSION_COOKIE_SECURE=True


from datetime import timedelta

# Set the time after which the session expires. Flask's default is 31 days.
# Default: ``timedelta(hours=1)`` corresponds to 1 hour.
PERMANENT_SESSION_LIFETIME = timedelta(hours=1)

# Folder containing the theme to use.
# Default: ``fedora``.
THEME_FOLDER = 'fedora'

# Which authentication method to use, defaults to `fas` can be or `local`
# Default: ``fas``.
MM_AUTHENTICATION = 'fas'

# If the authentication method is `fas`, groups in which should be the user
# to be recognized as an admin.
ADMIN_GROUP = ['sysadmin-main', 'sysadmin-web']

# Email of the admin to which send notification or error
ADMIN_EMAIL = ['admin@fedoraproject.org']

# Email address used in the 'From' field of the emails sent.
# Default: ``nobody@fedoraproject.org``.
EMAIL_FROM = 'nobody@fedoraproject.org'

# SMTP server to use,
# Default: ``localhost``.
SMTP_SERVER = 'bastion{{ env_suffix }}.fedoraproject.org'

# If the SMTP server requires authentication, fill in the information here
# SMTP_USERNAME = 'username'
# SMTP_PASSWORD = 'password'

# When this is set to True, an additional menu item is shown which can
# be used to browse the different statistics generated by
# mirrorlist_statistics.py.
SHOW_STATISTICS = True

# This is the directory the code enabled by SHOW_STATISTICS will use
# to locate the statistics files and display them.
STATISTICS_BASE = '/var/www/mirrormanager-statistics/data'

# Countries which have to be excluded.
EMBARGOED_COUNTRIES = ['CU', 'IR', 'KP', 'SD', 'SY']

# When this is set to True, an additional menu item is shown which
# displays the maps generated with mm2_generate-worldmap.
SHOW_MAPS = True

# Location of the static map displayed in the map tab.
STATIC_MAP = '/map/map.png'

# Location of the interactive openstreetmap based map.
INTERACTIVE_MAP = '/map/mirrors.html'

# The crawler can generate propagation statistics which can be
# converted into svg/pdf with mm2_propagation. These files
# can be displayed next to the statistics and maps tab if desired.
SHOW_PROPAGATION = True

# Where to look for the above mentioned propagation images.
PROPAGATION_BASE = '/var/www/mirrormanager-statistics/data/propagation'

# Disable master rsync server ACL
# Fedora does not use it and therefore it is set to False
MASTER_RSYNC_ACL = False

# When this is set to True, the session cookie will only be returned to the
# server via ssl (https). If you connect to the server via plain http, the
# cookie will not be sent. This prevents sniffing of the cookie contents.
# This may be set to False when testing your application but should always
# be set to True in production.
# Default: ``True``.
MM_COOKIE_REQUIRES_HTTPS = True

# The name of the cookie used to store the session id.
# Default: ``.MirrorManager``.
MM_COOKIE_NAME = 'MirrorManager'

# If this variable is set (and the directory exists) the crawler
# will create per host log files in MM_LOG_DIR/crawler/<hostid>.log
# which can the be used in the web interface by the mirror admins.
# Other parts besides the crawler are also using this variable to
# decide where to store log files.
MM_LOG_DIR = '-'

# This is used to exclude certain protocols to be entered
# for host category URLs at all.
# The following is the default for Fedora to exclude FTP based
# mirrors to be added. Removing this confguration option
# or setting it to '' removes any protocol restrictions.
MM_PROTOCOL_REGEX = '^(?!ftp)(.*)$'

# The netblock size parameters define which netblock sizes can be
# added by a site administrator. Larger networks can only be added by
# mirrormanager admins.
MM_IPV4_NETBLOCK_SIZE = '/16'
MM_IPV6_NETBLOCK_SIZE = '/32'

# If not specified the application will rely on the root_url when sending
# emails, otherwise it will use this URL
# Default: ``None``.
APPLICATION_URL = None

# Boolean specifying wether to check the user's IP address when retrieving
# its session. This make things more secure (thus is on by default) but
# under certain setup it might not work (for example is there are proxies
# in front of the application).
CHECK_SESSION_IP = True

# Specify additional rsync parameters for the crawler
# # --timeout 14400: abort rsync crawl after 4 hours
# # --no-human-readable: because rsync made things pretty by default in 3.1.x
CRAWLER_RSYNC_PARAMETERS = '--no-motd --timeout 14400 --exclude=lost+found --no-human-readable'

# This is a list of directories which MirrorManager will ignore while guessing
# the version and architecture from a path.
SKIP_PATHS_FOR_VERSION = [
    'pub/alt',
    'pub/fedora/linux/releases/test',
    'pub/archive',
    'pub/fedora-secondary/development/rawhide/s390/'
    'pub/fedora-secondary/development/rawhide/Modular/ppc64/os',
    'pub/fedora-secondary/development/rawhide/Modular/ppc64/debug/tree'
]

###
# Configuration options used by the crons
###

# Specify whether the crawler should send a report by email
CRAWLER_SEND_EMAIL =  False

# If a host fails for CRAWLER_AUTO_DISABLE times in a row
# the host will be disable automatically (user_active)
CRAWLER_AUTO_DISABLE = 4

UMDL_PREFIX = '/srv/'

umdl_master_directories = [
    {
        'type': 'directory',
        'path': '/srv/pub/epel/',
        'category': 'Fedora EPEL'
    },
    {
        'type': 'directory',
        'path': '/srv/pub/fedora/linux/',
        'category': 'Fedora Linux'
    },
    {
        'type': 'directory',
        'path': '/srv/pub/fedora-secondary/',
        'category': 'Fedora Secondary Arches'
    },
    {
        'type': 'directory',
        'path': '/srv/pub/archive/',
        'category': 'Fedora Archive'
    },
    {
        'type': 'directory',
        'path': '/srv/pub/alt/',
        'category': 'Fedora Other'
    },
    {
        'type': 'directory',
        'path': '/srv/codecs.fedoraproject.org/',
        'category': 'Fedora Codecs'
    },
#    {
#        'type':'directory',
#        'path':'../testdata/pub/fedora/linux/',
#        'category':'Fedora Linux',
#        'excludes':['.*/core/?.*', '.*/extras/?.*', '.*/[7-8]/?.*' ]
#    },
#    {
#        'type':'rsync',
#        'url':'rsync://archive.ubuntu.com/ubuntu/',
#        'category':'Ubuntu Archive'
#    },
#    {
#        'type':'rsync',
#        'url':'rsync://releases.ubuntu.com/releases/',
#        'category':'Ubuntu CD Images'
#        },
#    {
#        'type':'rsync',
#        'url':'rsync://ports.ubuntu.com/ubuntu-ports/',
#        'category':'Ubuntu Ports Archive'
#    },
#    {
#        'type':'rsync',
#        'url':'rsync://security.ubuntu.com/ubuntu/',
#        'category':'Ubuntu Security Archive'
#    },
]
