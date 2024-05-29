{% if env == "staging" %}
from werkzeug.middleware.proxy_fix import ProxyFix
from tahrir.app import create_app
application = create_app()
application.wsgi_app = ProxyFix(application.wsgi_app, x_proto=1, x_host=1)
{% else %}
from pyramid.paster import get_app, setup_logging
ini_path = '/etc/badges/tahrir.ini'
setup_logging(ini_path)

application = get_app(ini_path, 'main')
{% endif %}
