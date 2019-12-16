#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:5432
/root/wait-for-it.sh -t 60 rabbitmq:5672

# Adapt configuration from ENV variables
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/hobo.template > /etc/nginx/conf.d/hobo.conf
envsubst '${EMAIL} ${ENV} ${DOMAIN}' < /tmp/config.template > /tmp/config.json
envsubst '${EMAIL} ${ENV} ${DOMAIN}' < /tmp/cook.sh.template > /tmp/cook.sh
envsubst '${EMAIL} ${ENV} ${DOMAIN}' < /tmp/hobo.recipe.template > /tmp/recipe.json
chmod +x /tmp/cook.sh

# Start NGINX
service nginx start

# Start HOBO service
service hobo restart

# Start HOBO Agent
service supervisor start

exec "$@"
