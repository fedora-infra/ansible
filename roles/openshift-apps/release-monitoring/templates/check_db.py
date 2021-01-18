#!/bin/python3

from alembic import config, script
from alembic.runtime import migration
from sqlalchemy import engine

from anitya.config import config


def check_current_head(alembic_cfg, connectable):
    # type: (config.Config, engine.Engine) -> bool
    directory = script.ScriptDirectory.from_config(alembic_cfg)
    with connectable.begin() as connection:
        context = migration.MigrationContext.configure(connection)
        return set(context.get_current_heads()) == set(directory.get_heads())

if __name__ == "__main__":
    # Main
    engine = create_engine(config["DB_URL"], echo=config.get("SQL_DEBUG", False))
    cfg = config.Config("/etc/anitya/alembic.ini")
    if(not check_current_head(cfg, e)):
        print("ERROR: Current database head is not newest")
        exit(1)
