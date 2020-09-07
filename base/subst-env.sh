#!/usr/bin/env bash

set -eu

/root/check-env.sh

export APPNAME=$1
envsubst '${ENV} ${DOMAIN} $AUTHENTIC_SUBDOMAIN $COMBO_SUBDOMAIN $COMBO_ADMIN_SUBDOMAIN $FARGO_SUBDOMAIN $HOBO_SUBDOMAIN $PASSERELLE_SUBDOMAIN $WCS_SUBDOMAIN $CHRONO_SUBDOMAIN $BIJOE_SUBDOMAIN' < "/etc/nginx/conf.d/$1.template" > "/etc/nginx/conf.d/$1.conf"
envsubst '$RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT' < /etc/hobo-agent/settings.d/broker.template > /etc/hobo-agent/settings.d/broker.py
# Needs to be in a directory that can be read by a non-root user, so not "/root"
chmod 755 /home/pyenv.py
