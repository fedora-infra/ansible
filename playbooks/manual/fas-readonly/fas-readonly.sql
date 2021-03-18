--
-- Make fas read only
--


REVOKE ALL PRIVILEGES on people from fas;
GRANT SELECT on people to fas;

-- This needs to stay so that people can still login.
GRANT update (last_seen) on people to fas;

REVOKE ALL PRIVILEGES on groups from fas;
GRANT SELECT on groups to fas;

REVOKE ALL PRIVILEGES on group_roles from fas;
GRANT SELECT on group_roles to fas;

REVOKE ALL PRIVILEGES on person_roles from fas;
GRANT SELECT on person_roles to fas;

REVOKE ALL PRIVILEGES on person_roles_fpca from fas;
GRANT SELECT on person_roles_fpca to fas;

REVOKE ALL PRIVILEGES on bugzilla_queue from fas;
GRANT SELECT on bugzilla_queue to fas;
