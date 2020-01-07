#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}

# Adapt configuration from ENV variables
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/hobo.template > /etc/nginx/conf.d/hobo.conf
envsubst '${EMAIL} ${ENV} ${DOMAIN} ${HTTPS_PORT} ${DB_HOST} ${DB_WCS_PASS}' < /tmp/config.template > /tmp/config.json
envsubst '${EMAIL} ${ENV} ${DOMAIN} ${HTTPS_PORT}' < /tmp/cook.sh.template > /tmp/cook.sh
envsubst '${EMAIL} ${ENV} ${DOMAIN} ${HTTPS_PORT} ${SUPERUSER_PASS}' < /tmp/hobo.recipe.template > /tmp/recipe.json
chmod +x /tmp/cook.sh

# Start NGINX
service nginx start

# Start HOBO service
service hobo restart

# Start HOBO Agent
service supervisor start

exec "$@"
