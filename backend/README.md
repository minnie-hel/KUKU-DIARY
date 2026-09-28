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

## 3. Deploy on kukudiary.com

Point the web server (Nginx / Apache) to Gunicorn:

```bash
source .venv/bin/activate
gunicorn kuku.wsgi:application --bind 127.0.0.1:8000 --workers 3
```

Nginx example:

```nginx
server {
    listen 80;
    server_name kukudiary.com www.kukudiary.com;

    client_max_body_size 20M;

    location /static/ {
        alias /path/to/KUKU DIARY/backend/staticfiles/;
    }
    location /media/ {
        alias /path/to/KUKU DIARY/backend/media/;
    }
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

Then:

```bash
python manage.py collectstatic --noinput
```

Set `PUBLIC_BASE_URL=http://www.kukudiary.com` in `.env`.

## Auth notes

In `DJANGO_DEBUG=True`, register/login OTP responses include an `otp` field so you can verify without SMS. Turn DEBUG off in production and connect an SMS gateway.
