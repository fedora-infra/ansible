#
# This is the config file for Noggin as intended to be used in OpenShift
#


def from_file(path):
    return open(path, 'r').read().strip()


{% if subdir is defined %}
# Deployed to a subpath
APPLICATION_ROOT = '{{ subdir }}/'
{% endif %}

# IPA settings
FREEIPA_SERVERS = {{ ipa_server_nodes }}
FREEIPA_CACERT = '/etc/ipa/ca.crt'

# Cookies
SESSION_COOKIE_NAME = 'noggin'
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SECURE = True

# FreeIPA
FREEIPA_ADMIN_USER = "noggin"

# How many minutes before a password reset request expires
PASSWORD_RESET_EXPIRATION = 30

# Email
MAIL_FROM = "Fedora Account System <fas@fedoraproject.org>"
MAIL_DEFAULT_SENDER = "Fedora Account System <fas@fedoraproject.org>"
MAIL_SERVER = "bastion.fedoraproject.org"

# Theme
THEME = "{{ noggin_theme }}"

# Auto-gen avatar type to show if no avatar set
AVATAR_DEFAULT_TYPE = "retro"


# Don't allow regsitration with these email domains
MAIL_DOMAIN_BLOCKLIST = [
    "fedoraproject.org",
    "centosproject.org",
]

# Banners
TEMPLATES_CUSTOM_DIRECTORIES = ["/etc/noggin-templates"]
ACCEPT_IMAGES_FROM = ["pagure.io"]

# Those file should be mounted from OpenShift secrets
FREEIPA_ADMIN_PASSWORD = from_file('/etc/noggin-secrets/ipa-admin')
FERNET_SECRET = from_file('/etc/noggin-secrets/fernet').encode('utf-8')
SECRET_KEY = from_file('/etc/noggin-secrets/session').encode('utf-8')

# Spam checking
# BASSET_URL = None

# To disable registration:
# REGISTRATION_OPEN = False
