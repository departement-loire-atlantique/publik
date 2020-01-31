#!/bin/bash

for file in config.env secret.env
do
  if [ ! -f data/$file ]; then
    echo "ERROR, please create data/$file using the template $file.template"
    exit 1
  fi
done

if [ ! -f ./data/hosts ]; then
  touch ./data/hosts
fi

docker-compose up --no-build --abort-on-container-exit
