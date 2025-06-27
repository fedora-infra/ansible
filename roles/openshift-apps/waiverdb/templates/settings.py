{% if env == 'staging' %}
DATABASE_URI = 'postgresql+psycopg2://waiverdb@db01.stg.{{datacenter}}.fedoraproject.org:5432/waiverdb'
RESULTSDB_API_URL = 'https://resultsdb.stg.fedoraproject.org/api/v2.0'
CORS_URL = 'https://bodhi.stg.fedoraproject.org'
OVERWRITE_REDIRECT_URI = 'https://waiverdb.stg.fedoraproject.org/oidc_callback'
OIDC_REQUIRED_SCOPE = 'https://waiverdb.stg.fedoraproject.org/oidc/create-waiver'
{% else %}
DATABASE_URI = 'postgresql+psycopg2://waiverdb@db01.{{datacenter}}.fedoraproject.org:5432/waiverdb'
RESULTSDB_API_URL = 'https://resultsdb.fedoraproject.org/api/v2.0'
CORS_URL = 'https://bodhi.fedoraproject.org'
OVERWRITE_REDIRECT_URI = 'https://waiverdb.fedoraproject.org/oidc_callback'
OIDC_REQUIRED_SCOPE = 'https://waiverdb.fedoraproject.org/oidc/create-waiver'
{% endif %}
MESSAGE_BUS_PUBLISH = True
AUTH_METHOD = 'OIDC'
OIDC_CLIENT_SECRETS = '/etc/secret/client_secrets.json'
OIDC_USERNAME_FIELD = 'sub'
OIDC_OVERWRITE_REDIRECT_URI = '{{ waiverdb_oidc_overwrite_redirect_uri }}'
PREFERRED_URL_SCHEME='https'
SUPERUSERS = ['bodhi@service']
PORT = 8080
