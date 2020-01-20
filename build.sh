#!/bin/bash

docker-compose build
docker-compose pull pgadmin rabbitmq mailcatcher
