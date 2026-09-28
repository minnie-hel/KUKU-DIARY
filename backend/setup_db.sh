#!/usr/bin/env bash
set -euo pipefail

DB_NAME="${DB_NAME:-kuku}"
DB_USER="${DB_USER:-kuku}"
DB_PASSWORD="${DB_PASSWORD:-kuku_diary_2026}"

echo "Creating PostgreSQL role '${DB_USER}' and database '${DB_NAME}'..."

sudo -u postgres psql <<SQL
DO \$\$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '${DB_USER}') THEN
    CREATE ROLE ${DB_USER} LOGIN PASSWORD '${DB_PASSWORD}';
  ELSE
    ALTER ROLE ${DB_USER} WITH LOGIN PASSWORD '${DB_PASSWORD}';
  END IF;
END
\$\$;
SQL

if sudo -u postgres psql -tAc "SELECT 1 FROM pg_database WHERE datname='${DB_NAME}'" | grep -q 1; then
  echo "Database ${DB_NAME} already exists."
else
  sudo -u postgres createdb -O "${DB_USER}" "${DB_NAME}"
fi

sudo -u postgres psql -d "${DB_NAME}" -c "GRANT ALL ON SCHEMA public TO ${DB_USER};"
echo "Done. Database '${DB_NAME}' is ready."
