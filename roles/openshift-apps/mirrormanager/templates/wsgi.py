from werkzeug.middleware.proxy_fix import ProxyFix
from mirrormanager2.app import create_app
application = create_app()
application.wsgi_app = ProxyFix(application.wsgi_app, x_proto=1, x_host=1)
