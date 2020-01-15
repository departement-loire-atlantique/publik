#!/bin/bash

docker-compose down -v --rmi 'local'
docker-compose rm -v
