#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
PGDATA="$ROOT/.pgdata"
BIN=/usr/lib/postgresql/16/bin
SOCKDIR=/tmp/kuku_pg_socket
mkdir -p "$SOCKDIR"
if [ ! -f "$PGDATA/PG_VERSION" ]; then
  "$BIN/initdb" -D "$PGDATA" --auth=trust --username=kuku --encoding=UTF8 --no-locale
fi
"$BIN/pg_ctl" -D "$PGDATA" status >/dev/null 2>&1 || \
  "$BIN/pg_ctl" -D "$PGDATA" -l "$PGDATA/logfile" -o "-p 5433 -k $SOCKDIR" start
"$BIN/psql" -h 127.0.0.1 -p 5433 -U kuku -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='kuku'" | grep -q 1 || \
  "$BIN/createdb" -h 127.0.0.1 -p 5433 -U kuku kuku
echo "PostgreSQL database 'kuku' is running on port 5433."
