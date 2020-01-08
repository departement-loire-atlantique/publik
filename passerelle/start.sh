#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}

# Adapt configuration from ENV variables
envsubst '$RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT' < /etc/hobo-agent/settings.d/broker.template > /etc/hobo-agent/settings.d/broker.py
envsubst '$DEBUG $ALLOWED_HOSTS $DB_PASSERELLE_PASS $DB_PORT' < /etc/passerelle/settings.d/custom.template > /etc/passerelle/settings.d/custom.py
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/passerelle.template > /etc/nginx/conf.d/passerelle.conf

# Start passerelle
service nginx start
service passerelle start

# Start HOBO Agent
service supervisor start

exec "$@"
