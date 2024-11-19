#
# This is the config file for Tahrir as intended to be used in OpenShift
#


{% if env == 'staging' %}
SECRET_KEY = "{{tahrirstgSessionSecret}}"
{% else %}
SECRET_KEY = "{{tahrirSessionSecret}}"
{% endif %}

TEMPLATES_AUTO_RELOAD = False
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SECURE = True

{% if env == 'staging' %}
SQLALCHEMY_DATABASE_URI = "postgresql://{{tahrirDBUser}}:{{tahrirstgDBPassword}}@db01.stg.iad2.fedoraproject.org/tahrir"
TAHRIR_TITLE = "Fedora Badges (staging!)"
{% else %}
SQLALCHEMY_DATABASE_URI = "postgresql://{{tahrirDBUser}}:{{tahrirDBPassword}}@db-tahrir/tahrir"
TAHRIR_TITLE = "Fedora Badges"
{% endif %}
OIDC_CLIENT_SECRETS = "/etc/badges/client_secrets.json"

TAHRIR_ADMIN_GROUPS = ["sysadmin-main", "sysadmin-badges"]
TAHRIR_DEFAULT_ISSUER = "fedora-project"
TAHRIR_DEFAULT_AVATAR = "retro"
TAHRIR_DISPLAY_TAGS = ["content", "development", "community", "quality", "event", "miscellaneous"]
TAHRIR_PNGS_PATH = "/var/lib/badges/pngs"
TAHRIR_STLS_PATH = "/var/lib/badges/stls"
TAHRIR_SITEDOCS_SUBDIR = "../fedora-sitedocs"
TAHRIR_USE_FEDMSG = True
TAHRIR_EMAIL_DOMAIN = "{{env_prefix}}fedoraproject.org"
TAHRIR_FAS_URL = "https://accounts{{env_suffix}}.fedoraproject.org"

TAHRIR_SOCIAL_TWITTER = True
TAHRIR_SOCIAL_TWITTER_USER_TEXT = "Check out all these #fedorabadges :trophy:"
TAHRIR_SOCIAL_TWITTER_USER_HASH = "#fedora"

# If this is true, we'll store the email from the user's FAS account, if
# not, then we'll use their FAS_USERNAME@fedoraproject.org.  For Fedora
# Infrastructure we want this to be false due to some inconsistencies between
# the fedbadges backend awarder and the tahrir frontend.  Other deployments
# may set this to true with no problem.
TAHRIR_USE_OPENID_EMAIL = False

# Cache
CACHE = {
# disabled, trying to see if this fix this bug
# https://pagure.io/fedora-infrastructure/issue/8689
    "backend": "dogpile.cache.null",
    "expiration_time": 100,
    "arguments": {
        {% if env == 'staging' %}
        "url": "memcached02{{env_suffix}}:11211",
        {% else %}
        "url": "memcached01{{env_suffix}}:11211",
        {% endif %}
    "distributed_lock": True,
    "lock_timeout": 5,
    },
}
