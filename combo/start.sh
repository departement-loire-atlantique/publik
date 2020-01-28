#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/usr/local/bin/wait-for-it.sh -t 60 db:5432
/usr/local/bin/wait-for-it.sh -t 60 rabbitmq:5672

# Adapt configuration from ENV variables
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/combo.template > /etc/nginx/conf.d/combo.conf

# Start combo
service nginx start
service combo start

# Start HOBO Agent
service supervisor start

exec "$@"
