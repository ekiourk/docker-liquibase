#!/bin/bash

if [ -z "$1" ]
  then
    echo "ERROR: No version number supplied" 1>&2
    exit 1
fi

ver=3.3.3-$1

docker build -t ekiourk/liquibase:$ver .
docker tag -f ekiourk/liquibase:$ver ekiourk/liquibase:latest
docker push ekiourk/liquibase:$ver
docker push ekiourk/liquibase:latest