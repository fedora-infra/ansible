#!/usr/bin/env python3

import os
import shelve
from argparse import ArgumentParser

import sqlalchemy as sa
from sqlalchemy.ext.declarative import declarative_base


Base = declarative_base()


class Cookie(Base):
    __tablename__ = "cookies"
    __table_args__ = (
        sa.Index("idx_cookies_to_user_release", "to_user", "release"),
    )
    from_user = sa.Column(sa.String(254), nullable=False, primary_key=True)
    to_user = sa.Column(sa.String(254), nullable=False, primary_key=True)
    release = sa.Column(sa.String(63), nullable=False, primary_key=True)
    value = sa.Column(sa.Integer, nullable=False, default=1)
    date = sa.Column(sa.DateTime, nullable=False, server_default=sa.func.current_timestamp())


def get_pg_url():
    with open(os.path.expanduser("~/.pgpass")) as fh:
        for line in fh:
            hostname, port, database, username, password = line.strip().split(":")
            if username == "maubot":
                return f"postgresql://{username}:{password}@{hostname}/{database}"


def parse_args():
    parser = ArgumentParser()
    parser.add_argument("-i", "--instance", required=True, help="The maubot instance name")
    parser.add_argument("karma_db", help="The Limnoria Karma DB")
    # parser.add_argument("cookies_db", help="The Maubot Cookies DB")
    return parser.parse_args()


def main():
    args = parse_args()
    karma_data = shelve.open(args.karma_db, flag="r", protocol=2)
    # engine = sa.create_engine(f"sqlite:///{args.cookies_db}")
    engine = sa.create_engine(get_pg_url())
    Cookie.__table__.schema = f"mbp_{args.instance}"
    # Base.metadata.create_all(engine)
    Session = sa.orm.sessionmaker(bind=engine)
    session = Session()
    for mode, data in karma_data.items():
        direction, release = mode.split("-")
        if direction != "forwards":
            continue
        if not release.startswith("f"):
            continue
        print(release, len(data))
        for agent, gifts in data.items():
            for recip, value in gifts.items():
                cookie = Cookie(from_user=agent, to_user=recip, release=release.upper(), value=value)
                session.add(cookie)
                try:
                    session.commit()
                except sa.exc.IntegrityError:
                    session.rollback()
                    continue


if __name__ == "__main__":
    main()
