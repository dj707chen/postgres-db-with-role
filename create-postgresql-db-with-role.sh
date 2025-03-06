#!/bin/bash

set -e
set -u

function create_role_in_db() {
  local database=$1
  local user=$2
  local role=$3
  echo "Creating role '$role' and database '$database'"
  psql -v ON_ERROR_STOP=1 --username "$user" -d "$database" <<-EOSQL
    CREATE ROLE "$role";
EOSQL
  echo "Granting role '$role' to user '$user'"
  psql -v ON_ERROR_STOP=1 --username "$user" -d "$database" <<-EOSQL
    GRANT "$role" TO "$user";
EOSQL
  echo "Granting all privileges on database '$database' to role '$role'"
  psql -v ON_ERROR_STOP=1 --username "$user" -d "$database" <<-EOSQL
    GRANT ALL PRIVILEGES ON DATABASE "$database" TO "$role";
EOSQL
  echo "Granting all privileges on schema 'public' to role '$role'"
  psql -v ON_ERROR_STOP=1 --username "$user" -d "$database" <<-EOSQL
    GRANT ALL PRIVILEGES ON SCHEMA public TO "$role";
EOSQL
}

create_role_in_db $POSTGRES_DB $POSTGRES_USER $POSTGRES_ROLE

# Optionally create a test user if TEST_USERNAME and TEST_USER_PASSWORD variables are define, test container then connect to it
if [[ ${TEST_USERNAME+x} && ${TEST_USER_PASSWORD+x} ]]; then
  echo "Creating test user '$TEST_USERNAME'"
  psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOSQL
    CREATE USER $TEST_USERNAME WITH PASSWORD '$TEST_USER_PASSWORD' IN ROLE "$POSTGRES_ROLE";
EOSQL
fi
