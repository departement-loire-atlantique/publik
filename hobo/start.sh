#!/bin/bash

# Fail on errors
set -eu

# Wait for dependencies
/root/wait-for-it.sh -t 60 db:${DB_PORT}
/root/wait-for-it.sh -t 60 rabbitmq:${RABBITMQ_PORT}
/root/subst-env.sh "hobo"

envsubst '${EMAIL} ${ENV} ${DOMAIN} ${HTTPS_PORT} ${DB_WCS_PASS} $COMBO_SUBDOMAIN' < /tmp/config.template > /tmp/config.json
envsubst '${EMAIL} ${ENV} ${DOMAIN} ${HTTPS_PORT} $AUTHENTIC_SUBDOMAIN $COMBO_SUBDOMAIN $COMBO_ADMIN_SUBDOMAIN $FARGO_SUBDOMAIN $HOBO_SUBDOMAIN $PASSERELLE_SUBDOMAIN $WCS_SUBDOMAIN' < /tmp/cook.sh.template > /tmp/cook.sh
envsubst '${EMAIL} ${ENV} ${DOMAIN} ${HTTPS_PORT} ${SUPERUSER_PASS} $AUTHENTIC_SUBDOMAIN $COMBO_SUBDOMAIN $COMBO_ADMIN_SUBDOMAIN $FARGO_SUBDOMAIN $HOBO_SUBDOMAIN $PASSERELLE_SUBDOMAIN $WCS_SUBDOMAIN' < /tmp/hobo.recipe.template > /tmp/recipe.json
chmod +x /tmp/cook.sh

# Start NGINX
service nginx start

# Start HOBO service
service hobo restart

# Start HOBO Agent
service supervisor start
