#
# This is the config file for Datagrepper as intended to be used in OpenShift
#

APP_PATH = "https://apps{{ env_suffix }}.fedoraproject.org/datagrepper2"
DEFAULT_QUERY_DELTA = 3600
DATANOMMER_SQLALCHEMY_URL = "postgresql://{{ datanommerDBUser }}:{{ datanommerDBPassword }}@db-datanommer01{{ env_suffix }}.iad2.fedoraproject.org/datanommer2"
