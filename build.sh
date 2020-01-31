#!/bin/bash

docker build -t julienbayle/publik:latest-base base/
docker-compose build
docker-compose pull pgadmin rabbitmq mailcatcher
