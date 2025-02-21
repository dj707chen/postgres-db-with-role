FROM postgres:15.8
COPY create-postgresql-db-with-role.sh /docker-entrypoint-initdb.d/