#!/usr/bin/env bash

err=false

for VAR in ERROR_MAIL_AUTHOR ERROR_MAIL_ADDR DOMAIN EMAIL RABBITMQ_DEFAULT_USER POSTGRES_PASSWORD DB_HOBO_PASS DB_PASSERELLE_PASS DB_COMBO_PASS DB_FARGO_PASS DB_WCS_PASS DB_AUTHENTIC_PASS RABBITMQ_DEFAULT_PASS SUPERUSER_PASS DB_PORT RABBITMQ_PORT RABBITMQ_MANAGEMENT_PORT HTTP_PORT HTTPS_PORT MAILCATCHER_SMTP_PORT MAILCATCHER_HTTP_PORT PGADMIN_PORT
do
  if [ -z ${!VAR} ]
  then
    echo "$VAR MUST be set and MUST NOT be empty"
    err=true
  fi
done

for VAR in ENV DEBUG ALLOWED_HOSTS 
do
  if [ -z ${!VAR+x} ]
  then
    echo "$VAR MUST be set"
    err=true
  fi
done

if [ "$err" = true ]
then
  exit 1
fi

envsubst '${ENV} ${DOMAIN}' < "/etc/nginx/conf.d/$1.template" > "/etc/nginx/conf.d/$1.conf"
envsubst '$RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT' < /etc/hobo-agent/settings.d/broker.template > /etc/hobo-agent/settings.d/broker.py
envsubst '$DEBUG $ALLOWED_HOSTS $DB_PORT $DB_HOBO_PASS $DB_PASSERELLE_PASS $DB_COMBO_PASS $DB_FARGO_PASS $DB_WCS_PASS $DB_AUTHENTIC_PASS $RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT $ERROR_MAIL_AUTHOR $ERROR_MAIL_ADDR $MAILCATCHER_SMTP_PORT' < /root/pyenv.template > /home/pyenv.py
# Needs to be in a directory that can be read by a non-root user, so not "/root"
chmod 755 /home/pyenv.py
