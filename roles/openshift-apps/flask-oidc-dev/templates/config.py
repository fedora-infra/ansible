#
# This is the config file for Test Auth as intended to be used in OpenShift
#


# Deployed to a subpath
# APPLICATION_ROOT = '/test-auth/'

# Cookies
SECRET_KEY = "{{ flask_oidc_dev_session_secret }}"
SESSION_COOKIE_NAME = 'flask-oidc-dev'
SESSION_COOKIE_HTTPONLY = True
SESSION_COOKIE_SECURE = True

# Auth
OIDC_CLIENT_SECRETS = "/etc/flask-oidc-dev/oidc.json"
OIDC_SCOPES = "openid profile email https://id.fedoraproject.org/scope/groups"
OIDC_INTROSPECTION_AUTH_METHOD = "client_secret_post"
OIDC_CALLBACK_ROUTE = "/oidc_callback"
OPENID_ENDPOINT = "https://id{{ env_suffix }}.fedoraproject.org/openid/"
FAS_OPENID_ENDPOINT = "https://id{{ env_suffix }}.fedoraproject.org/openid/"
