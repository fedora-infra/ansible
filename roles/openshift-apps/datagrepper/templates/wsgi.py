from werkzeug.middleware.proxy_fix import ProxyFix
from datagrepper.app import app as application
application.wsgi_app = ProxyFix(application.wsgi_app, x_proto=1, x_host=1)
