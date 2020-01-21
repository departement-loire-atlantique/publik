#!/bin/bash

for file in config.env .env secret.env
do
  if [ ! -f $file ]; then
    cp "$file.template" $file
  fi
done

if [ ! -f ./data/hosts ]; then
  touch ./data/hosts
fi

docker-compose up --no-build --abort-on-container-exit
