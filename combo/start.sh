#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}

# Adapt configuration from ENV variables
envsubst '$RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT' < /etc/hobo-agent/settings.d/broker.py > /etc/hobo-agent/settings.d/broker.py
envsubst '$DEBUG $ALLOWED_HOSTS $DB_COMBO_PASS $DB_PORT' < $SETTINGS_FILE > $SETTINGS_FILE
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/combo.template > /etc/nginx/conf.d/combo.conf

# Start combo
service nginx start
service combo start

# Start HOBO Agent
service supervisor start

exec "$@"
