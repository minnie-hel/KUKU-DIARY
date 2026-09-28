# KUKU DIARY

Smart poultry management app (Flutter) with a Django + PostgreSQL backend.

- Mobile app: this repository (`lib/`)
- Backend API: `backend/`
- Database: PostgreSQL database named **kuku**
- Production site: http://www.kukudiary.com

## Backend

See [backend/README.md](backend/README.md).

Local development on this machine uses a user-owned PostgreSQL cluster on **port 5433** (database `kuku`, user `kuku`):

```bash
cd backend
./start_local_postgres.sh
source .venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

```bash
cd backend
./start_local_postgres.sh
source .venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

API health: http://127.0.0.1:8000/api/health/

Admin: http://127.0.0.1:8000/admin/

The Flutter app (debug builds) talks to `http://192.168.1.52:8000/api`. Release builds use `http://www.kukudiary.com/api`. Override with:

```bash
flutter run --dart-define=API_BASE_URL=http://YOUR_LAN_IP:8000/api
```
