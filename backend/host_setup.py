"""
Run this once from cPanel: Setup Python App, Run script, host_setup.py

Add only stores the name. Run script is the button that executes this file.
It installs Python packages, creates the database tables, loads the catalog,
collects static files, and creates the admin user from .env.
Progress is written to setup_result.txt in this same folder.
"""
import os
import subprocess
import sys
import traceback
from pathlib import Path

APP_DIR = Path(__file__).resolve().parent
os.chdir(APP_DIR)
RESULT = APP_DIR / 'setup_result.txt'
lines = []


def save():
    RESULT.write_text('\n'.join(lines) + '\n', encoding='utf-8')


def main():
    lines.append('started')
    save()

    requirements = APP_DIR / 'requirements.txt'
    if not requirements.exists():
        raise FileNotFoundError(f'Missing {requirements}')

    lines.append('pip: installing requirements.txt')
    save()
    subprocess.check_call([sys.executable, '-m', 'pip', 'install', '-r', str(requirements)])
    lines.append('pip: ok')
    save()

    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'kuku.settings')
    import django

    django.setup()
    from django.contrib.auth import get_user_model
    from django.core.management import call_command

    call_command('migrate', interactive=False, verbosity=1)
    lines.append('migrate: ok')
    save()

    call_command('seed_catalog', verbosity=1)
    lines.append('seed_catalog: ok')
    save()

    call_command('collectstatic', interactive=False, verbosity=1)
    lines.append('collectstatic: ok')
    save()

    User = get_user_model()
    username = os.environ.get('SUPERUSER_USERNAME', 'admin').strip() or 'admin'
    email = os.environ.get('SUPERUSER_EMAIL', 'admin@kukudiary.com').strip() or 'admin@kukudiary.com'
    password = os.environ.get('SUPERUSER_PASSWORD', '')
    if User.objects.filter(username=username).exists():
        lines.append(f'superuser: {username} already exists')
    elif not password:
        lines.append('superuser: skipped. Add SUPERUSER_PASSWORD to .env and run host_setup.py again.')
    else:
        User.objects.create_superuser(username=username, email=email, password=password)
        lines.append(f'superuser: created {username}')
    lines.append('done')
    save()


if __name__ == '__main__':
    try:
        main()
    except Exception:
        lines.append(traceback.format_exc())
        save()
        raise
