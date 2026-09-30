# KUKU DIARY backend (Django + PostgreSQL)

API for the KUKU DIARY mobile app. All farm, marketplace, community, finance, vaccination, veterinary, and training data is stored in PostgreSQL database **kuku**.

Production domain: [http://www.kukudiary.com](http://www.kukudiary.com)

## 1. Create the database

On the server (or this machine) with PostgreSQL installed:

```bash
cd backend
chmod +x setup_db.sh
./setup_db.sh
```

This creates PostgreSQL user `kuku` and database `kuku`.

Copy environment file and set passwords:

```bash
cp .env.example .env
# edit DB_PASSWORD, DJANGO_SECRET_KEY, PUBLIC_BASE_URL
```

## 2. Install and migrate

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py seed_catalog
python manage.py createsuperuser
python manage.py runserver 0.0.0.0:8000
```

Health check: `http://127.0.0.1:8000/api/health/`

Admin: `http://127.0.0.1:8000/admin/`

## 3. Deploy on kukudiary.com (Duhosting cPanel)

The live host is Duhosting shared hosting with Python and PostgreSQL. Do not use the VPS commands below for that account. Follow [DEPLOY_CPANEL.md](DEPLOY_CPANEL.md). Upload `kukudiary-backend.zip` from the Desktop, then create the PostgreSQL database and the Python App in cPanel.

## 3b. Deploy on your own VPS

On the server (Ubuntu), with the domain's DNS A record pointing at the server:

```bash
sudo apt install -y python3-venv python3-pip postgresql nginx certbot python3-certbot-nginx
cd "/path/to/KUKU DIARY/backend"
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
```

Edit `.env` for production:

```
DJANGO_DEBUG=False
DJANGO_SECRET_KEY=<long random string>
DJANGO_ALLOWED_HOSTS=kukudiary.com,www.kukudiary.com
DB_PASSWORD=<the kuku database password>
DB_PORT=5432
PUBLIC_BASE_URL=https://www.kukudiary.com
```

Then create the database and load the schema plus the catalog (doctors, training, service providers). This seeds the platform catalog only — no farmer data; every farmer's records come from what they enter in the app:

```bash
sudo -u postgres psql -c "CREATE USER kuku WITH PASSWORD '<password>';"
sudo -u postgres psql -c "CREATE DATABASE kuku OWNER kuku;"
python manage.py migrate
python manage.py seed_catalog
python manage.py createsuperuser
python manage.py collectstatic --noinput
```

Run the app with Gunicorn (example systemd unit `/etc/systemd/system/kukudiary.service`):

```ini
[Service]
WorkingDirectory=/path/to/KUKU DIARY/backend
ExecStart=/path/to/KUKU DIARY/backend/.venv/bin/gunicorn kuku.wsgi:application --bind 127.0.0.1:8000 --workers 3
Restart=always
[Install]
WantedBy=multi-user.target
```

Nginx (`/etc/nginx/sites-available/kukudiary`), then `sudo certbot --nginx -d kukudiary.com -d www.kukudiary.com` for the free HTTPS certificate:

```nginx
server {
    listen 80;
    server_name kukudiary.com www.kukudiary.com;
    client_max_body_size 20M;

    location /static/ { alias /path/to/KUKU DIARY/backend/staticfiles/; }
    location /media/  { alias /path/to/KUKU DIARY/backend/media/; }
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Verify from anywhere: `curl https://www.kukudiary.com/api/health/` should return `{"status":"ok",...}`.

## 4. APK for distribution

The release build (with no override) points at the public server, so it works on any phone on any network:

```bash
flutter build apk --release --target-platform android-arm64
```

Accounts and farm data live only in the server database. Farmers who registered against a local development database must register again on the deployed server.

## Auth notes

Password reset still uses a one-time code. In `DJANGO_DEBUG=True` the code is returned in the API response so it can be tested without SMS. With `DJANGO_DEBUG=False` the code is never exposed, so connect an SMS gateway before relying on password reset in production. Registration and login use phone/email plus password and need no code.
