HOST= '0.0.0.0'
PORT = 8080
DEBUG = False
POLICIES_DIR = '/etc/greenwave/'
SUBJECT_TYPES_DIR = '/src/conf/subject_types'

{% if env == 'staging' %}
DIST_GIT_BASE_URL = 'https://src.stg.fedoraproject.org'
DIST_GIT_URL_TEMPLATE = '{DIST_GIT_BASE_URL}/{pkg_namespace}/{pkg_name}/raw/{rev}/f/gating.yaml'
KOJI_BASE_URL = 'https://koji.stg.fedoraproject.org/kojihub'
BODHI_URL = 'https://bodhi.stg.fedoraproject.org/'

SECRET_KEY = '{{stg_greenwave_secret_key}}'
WAIVERDB_API_URL = 'https://waiverdb.stg.fedoraproject.org/api/v1.0'
RESULTSDB_API_URL = 'https://resultsdb.stg.fedoraproject.org/api/v2.0'
GREENWAVE_API_URL = 'https://greenwave.stg.fedoraproject.org/api/v1.0'
CORS_URL = '*'
MESSAGING = "fedora-messaging"
{% else %}
DIST_GIT_BASE_URL = 'https://src.fedoraproject.org'
DIST_GIT_URL_TEMPLATE = '{DIST_GIT_BASE_URL}/{pkg_namespace}/{pkg_name}/raw/{rev}/f/gating.yaml'
KOJI_BASE_URL = 'https://koji.fedoraproject.org/kojihub'
BODHI_URL = 'https://bodhi.fedoraproject.org/'

SECRET_KEY = '{{prod_greenwave_secret_key}}'
WAIVERDB_API_URL = 'https://waiverdb.fedoraproject.org/api/v1.0'
RESULTSDB_API_URL = 'https://resultsdb.fedoraproject.org/api/v2.0'
GREENWAVE_API_URL = 'https://greenwave.fedoraproject.org/api/v1.0'
CORS_URL = 'https://bodhi.fedoraproject.org'
MESSAGING = "fedora-messaging"
{% endif %}

# TODO: This is for backwards compatibility. Remove in the near future.
import importlib  # noqa: E402
if importlib.util.find_spec("pymemcache") is None:
    greenwave_cache_backend = "dogpile.cache.memcached"
else:
    greenwave_cache_backend = "dogpile.cache.pymemcache"

CACHE = {
 'backend': greenwave_cache_backend,
 'expiration_time': 3600, # 3600 is 1 hour
 'arguments': {
     'url': 'greenwave-memcached:11211',
     'distributed_lock': True,
     # Release lock in case the owner was terminated.
     'lock_timeout': 120,
     # Retry if memcached is temporarily down.
     'enable_retry_client': True,
     'retry_attempts': 15,
     'retry_delay': 2,  # seconds
 }
}
