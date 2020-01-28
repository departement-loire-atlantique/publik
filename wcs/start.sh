#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/usr/local/bin/wait-for-it.sh -t 60 db:5432
/usr/local/bin/wait-for-it.sh -t 60 rabbitmq:5672

# Adapt configuration from ENV variables
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/wcs.template > /etc/nginx/conf.d/wcs.conf

# Start NGINX
service nginx start

# Start WCS
service wcs start

# Start HOBO Agent
service supervisor start

exec "$@"
