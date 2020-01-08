#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}

# Adapt configuration from ENV variable
envsubst '$RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT' < /etc/hobo-agent/settings.d/broker.template > /etc/hobo-agent/settings.d/broker.py
envsubst '$DEBUG $ALLOWED_HOSTS $DB_AUTHENTIC_PASS $DB_PORT $RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT $ERROR_MAIL_AUTHOR $ERROR_MAIL_ADDR $MAILCATCHER_SMTP_PORT' < /etc/authentic2-multitenant/config.template > /etc/authentic2-multitenant/config.py
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
