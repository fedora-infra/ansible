{% if env == 'staging' %}
DATABASE_URI = 'postgresql+psycopg2://waiverdb@db01.stg.iad2.fedoraproject.org:5432/waiverdb'
RESULTSDB_API_URL = 'https://resultsdb.stg.fedoraproject.org/api/v2.0'
CORS_URL = 'https://bodhi.stg.fedoraproject.org'
OVERWRITE_REDIRECT_URI = 'https://waiverdb.stg.fedoraproject.org/oidc_callback'
{% else %}
DATABASE_URI = 'postgresql+psycopg2://waiverdb@db01.iad2.fedoraproject.org:5432/waiverdb'
RESULTSDB_API_URL = 'https://resultsdb.fedoraproject.org/api/v2.0'
CORS_URL = 'https://bodhi.fedoraproject.org'
OVERWRITE_REDIRECT_URI = 'https://waiverdb.fedoraproject.org/oidc_callback'
{% endif %}
MESSAGE_BUS_PUBLISH = True
AUTH_METHOD = 'OIDC'
OIDC_REQUIRED_SCOPE = 'https://waiverdb.fedoraproject.org/oidc/create-waiver'
OIDC_CLIENT_SECRETS = '/etc/secret/client_secrets.json'
PREFERRED_URL_SCHEME='https'
SUPERUSERS = ['bodhi@service']
PORT = 8080
