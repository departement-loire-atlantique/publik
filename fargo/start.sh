#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 ${DB_HOST}:${DB_PORT}
/root/wait-for-it.sh -t 60 ${RABBITMQ_HOST}:${RABBITMQ_PORT}

# Adapt configuration from ENV variables
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/fargo.template > /etc/nginx/conf.d/fargo.conf

# Start FARGO
service nginx start
service fargo start

# Start HOBO Agent
service supervisor start

exec "$@"
