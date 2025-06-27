#
# This is the config file for Datagrepper as intended to be used in OpenShift
#

APP_PATH = "https://apps{{ env_suffix }}.fedoraproject.org/datagrepper"
DEFAULT_QUERY_DELTA = 86400
DATANOMMER_SQLALCHEMY_URL = "postgresql://datagrepper:{{ (env == 'production')|ternary(datagrepper_prod_db_password, datagrepper_stg_db_password) }}@{{ datanommer_db_hostname }}{{ env_suffix }}.{{datacenter}}.fedoraproject.org/datanommer2"

# Only allow ajax/websockets connections back to our domains.
# https://github.com/fedora-infra/datagrepper/pull/192
CONTENT_SECURITY_POLICY = "connect-src https://*.fedoraproject.org wss://*.fedoraproject.org"
