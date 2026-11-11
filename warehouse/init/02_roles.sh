#!/usr/bin/env bash
set -e

# Stop if pw is not set
: "${LOADER_PASSWORD:?LOADER_PASSWORD is not set}"
: "${TRANSFORMER_PASSWORD:?TRANSFORMER_PASSWORD is not set}"
: "${DASHBOARD_PASSWORD:?DASHBOARD_PASSWORD is not set}"

psql -v ON_ERROR_STOP=1 \
--username "$POSTGRES_USER" \
--dbname "$POSTGRES_DB" \
-v loader_pw="$LOADER_PASSWORD" \
-v transformer_pw="$TRANSFORMER_PASSWORD" \
-v dashboard_pw="$DASHBOARD_PASSWORD" \
<<'EOSQL'

-- roles
CREATE ROLE loader LOGIN PASSWORD :'loader_pw';
CREATE ROLE transformer LOGIN PASSWORD :'transformer_pw';
CREATE ROLE dashboard LOGIN PASSWORD :'dashboard_pw';

-- rights schema
GRANT USAGE, CREATE ON SCHEMA raw TO loader;

GRANT USAGE ON SCHEMA raw TO transformer;
GRANT USAGE, CREATE ON SCHEMA staging TO transformer;
GRANT USAGE, CREATE ON SCHEMA marts TO transformer;

GRANT USAGE ON SCHEMA marts TO dashboard;

-- rights tables
ALTER DEFAULT PRIVILEGES FOR ROLE loader IN SCHEMA raw GRANT SELECT ON TABLES TO transformer;
ALTER DEFAULT PRIVILEGES FOR ROLE transformer IN SCHEMA marts GRANT SELECT ON TABLES TO dashboard;

EOSQL
