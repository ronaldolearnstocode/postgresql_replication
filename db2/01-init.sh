\c pg_replica;
#!/bin/bash
set -e
export PGPASSWORD=$POSTGRES_USER;
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
  CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS' REPLICATION;
  CREATE DATABASE $APP_DB_NAME;
  GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME TO $APP_DB_USER;
  
  \connect $APP_DB_NAME $POSTGRES_USER
  CREATE SCHEMA cloudwalk;
  GRANT ALL ON SCHEMA cloudwalk TO $APP_DB_USER;
  CREATE TABLE IF NOT EXISTS cloudwalk.orders(
    id              integer GENERATED ALWAYS AS IDENTITY primary key,
    product_name    text,
    quantity        integer,
    order_date      date);
EOSQL

echo docker network inspect postgresql_replication_default | grep pg_master


