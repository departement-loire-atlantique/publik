#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}

# Adapt configuration from ENV variables
envsubst '$RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT' < /etc/hobo-agent/settings.d/broker.template > /etc/hobo-agent/settings.d/broker.py
envsubst '$DEBUG $ALLOWED_HOSTS $DB_WCS_PASS $DB_PORT $MAILCATCHER_SMTP_PORT' < /etc/wcs/settings.d/custom.template > /etc/wcs/settings.d/custom.py
envsubst '${ENV} ${DOMAIN}' < /etc/nginx/conf.d/wcs.template > /etc/nginx/conf.d/wcs.conf

# Start NGINX
service nginx start

# Start WCS
service wcs start

# Start HOBO Agent
service supervisor start

exec "$@"
