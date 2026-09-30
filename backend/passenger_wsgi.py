"""
cPanel Setup Python App entry point.
Application startup file: passenger_wsgi.py
Application entry point: application
"""
import os
import sys
import traceback

APP_DIR = os.path.dirname(os.path.abspath(__file__))
if APP_DIR not in sys.path:
    sys.path.insert(0, APP_DIR)

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'kuku.settings')


def _write_error(text):
    try:
        with open(os.path.join(APP_DIR, 'passenger_error.txt'), 'w', encoding='utf-8') as handle:
            handle.write(text)
    except OSError:
        pass


try:
    from django.core.wsgi import get_wsgi_application

    application = get_wsgi_application()
except Exception:
    _write_error(traceback.format_exc())
    raise
