#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}
/root/subst-env.sh

# Adapt configuration from ENV variable
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/authentic.template > /etc/nginx/conf.d/authentic.conf

# Start NGINX
service nginx start

# Start MEMCACHED
service memcached start

# Start HOBO Agent
service supervisor start

# Start Authentic
service authentic2-multitenant update
service authentic2-multitenant restart
service authentic2-multitenant status

exec "$@"
