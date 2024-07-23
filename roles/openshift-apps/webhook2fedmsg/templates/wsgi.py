from werkzeug.middleware.proxy_fix import ProxyFix
from webhook_to_fedora_messaging.main import create_app
application = create_app()
application.wsgi_app = ProxyFix(application.wsgi_app, x_proto=1, x_host=1)
