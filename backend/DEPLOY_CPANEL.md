# Deploy KUKU DIARY on Duhosting (cPanel)

The domain already points at Duhosting (`50.6.6.46`). The site folder is empty, so the API is not there yet. This puts the Django backend on that account. Farmer accounts and farm records are saved in PostgreSQL on the server. The catalog command only loads doctors, training, and service providers.

The phone app already calls `https://www.kukudiary.com/api`. No new APK is required after this is live.

Change the cPanel password before uploading. The one from the welcome email was copied into chat.

## 1. Create the PostgreSQL database

In cPanel open **PostgreSQL Databases**.

1. Create a database named `kuku`. cPanel will prefix it, often to `kukudiar_kuku`.
2. Create a database user and a password you choose.
3. Add that user to the database with **ALL PRIVILEGES**.

Write down the full database name, full username, and password. They go in `.env` exactly as cPanel shows them.

## 2. Create the Python application

In cPanel open **Setup Python App** → **Create Application**.

| Field | Type exactly this | Do not type |
| --- | --- | --- |
| Python version | Newest available, 3.10 or newer | |
| Application root | `kukudiary` | `/home/minnie/Desktop/KUKU DIARY/backend` |
| Application URL | `kukudiary.com/` | |
| Application startup file | `passenger_wsgi.py` | any full path |
| Application entry point | `application` | |

The startup file must be the filename only. cPanel looks for it inside the application root on the server (`/home/kukudiar/kukudiary/`). A path from your laptop is outside that folder, which produces: `Startup file ... is not in webapp directory`. Upload the zip into `kukudiary` before creating the app if that folder does not exist yet.

Create the application. cPanel shows a virtualenv path and a command that starts with `source .../activate`. Keep that page open.

## 3. Upload the backend

On this computer the upload package is:

`/home/minnie/Desktop/kukudiary-backend.zip`

In cPanel **File Manager**, open the `kukudiary` folder created above (it is in the home directory, not inside `public_html`). Upload the zip and **Extract** it there. `manage.py` and `passenger_wsgi.py` must sit directly inside `kukudiary/`, not inside an extra nested folder.

Do not upload the laptop `.env` or the `.venv` folder. The zip does not contain them.

## 4. Production settings file

In File Manager, inside `kukudiary`, copy `.env.production.example` to `.env`. Edit `.env`:

- `DJANGO_SECRET_KEY`: a long random string
- `DB_NAME`, `DB_USER`, `DB_PASSWORD`: the full names from step 1
- Leave `DJANGO_DEBUG=False`

## 5. Install and create the tables

On the Python App page, set the configuration file path to `requirements.txt` if asked, then run **Run Pip Install**. If that button is missing, open **Terminal** and run the `source .../activate` command from the Python App page, then:

```bash
cd ~/kukudiary
pip install -r requirements.txt
python manage.py migrate
python manage.py seed_catalog
python manage.py createsuperuser
python manage.py collectstatic --noinput
```

`createsuperuser` is the admin login for `https://www.kukudiary.com/admin/`. Remember that password. It is not a farmer login.

## 6. Restart and test

On the Python App page click **Restart**. Then from any network:

```bash
curl https://www.kukudiary.com/api/health/
```

Expected: `{"status":"ok","service":"kuku-diary","database":"kuku"}` (the database name in the message is the app label; the real database is the one in `.env`).

Open `https://www.kukudiary.com/` and you should see **KUKU DIARY API**, not a directory listing.

Install `/home/minnie/Desktop/KUKU-DIARY.apk` on a phone that is not on your home Wi-Fi. Register a new farmer. That account is stored on Duhosting. Accounts created on the laptop database are not on this server.

## If something fails

- **Directory listing instead of the API page:** the Python App URL is not `/`, or the app was not restarted.
- **500 error:** open cPanel **Errors**, or `~/kukudiary/stderr.log` if Passenger created one. The usual cause is a wrong `DB_NAME` / `DB_USER` / `DB_PASSWORD`.
- **DisallowedHost:** `DJANGO_ALLOWED_HOSTS` must include `kukudiary.com,www.kukudiary.com`.
- **Pip fails on Pillow or psycopg2:** tell Duhosting the Python App cannot install those packages. Do not switch the app to MySQL; the project is PostgreSQL.
