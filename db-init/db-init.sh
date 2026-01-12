#!/usr/bin/env bash
set -euo pipefail

echo "db-init: starting..."
echo "db-init: waiting for SQL Server..."

for i in {1..60}; do
  /opt/mssql-tools18/bin/sqlcmd \
    -S db \
    -U sa \
    -P "YourStrong!Passw0rd" \
    -C \
    -Q "SELECT 1" >/dev/null 2>&1 && break
  sleep 2
done

echo "db-init: creating database finance if not exists..."
/opt/mssql-tools18/bin/sqlcmd \
  -S db \
  -U sa \
  -P "YourStrong!Passw0rd" \
  -C \
  -Q "IF DB_ID('finance') IS NULL CREATE DATABASE finance;"

echo "db-init: done."
