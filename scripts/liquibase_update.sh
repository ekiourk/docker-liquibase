#!/bin/bash -e

if [ -z "$DB_USER" ]; then
  echo "No DB_USER supplied."
  exit 1
fi

if [ -z "$DB_SCHEMA_NAME" ]; then
  echo "No DB_SCHEMA_NAME supplied."
  exit 1
fi

if [ -z "$DB_PASS" ]; then
  echo "No DB_PASS supplied, using no password."
  DB_PASS=
fi
CONNECTION_STRING=jdbc:postgresql://$DB_PORT_5432_TCP_ADDR:$DB_PORT_5432_TCP_PORT/$DB_SCHEMA_NAME

echo "Setting up liquidbase.properties"
cat <<CONF > /opt/liquibase/db-schema/liquibase.properties
  driver: org.postgresql.Driver
  classpath: /usr/local/bin/postgresql-9.4-1204.jdbc4.jar
  url: $CONNECTION_STRING
  username: $DB_USER
  password: $DB_PASS
  changeLogFile: master.yml
CONF

cd /opt/liquibase/db-schema

count=1
until liquibase update
do
  printf "Applying changelogs ... $count\n"
  ((count++))
  if [ $count -eq 5 ]; then
    echo "Maximum number of retries reached. Exiting.."
    exit 1
  fi
  sleep 1
done
