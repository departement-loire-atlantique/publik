#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}

# Adapt configuration from ENV variables
envsubst '$RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT' < /etc/hobo-agent/settings.d/broker.template > /etc/hobo-agent/settings.d/broker.py
envsubst '$DEBUG $ALLOWED_HOSTS $DB_FARGO_PASS $DB_PORT' < /etc/fargo/settings.template > /etc/fargo/settings.py
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/fargo.template > /etc/nginx/conf.d/fargo.conf

# Start FARGO
service nginx start
service fargo start

# Start HOBO Agent
service supervisor start

exec "$@"
