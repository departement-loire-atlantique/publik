#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}
/root/subst-env.sh

# Adapt configuration from ENV variables
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/passerelle.template > /etc/nginx/conf.d/passerelle.conf

# Start passerelle
service nginx start
service passerelle start

# Start HOBO Agent
service supervisor start

exec "$@"
