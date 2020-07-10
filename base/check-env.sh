#!/bin/bash

err=false

for VAR in DB_HOBO_NAME DB_PASSERELLE_NAME DB_COMBO_NAME DB_FARGO_NAME DB_WCS_NAME DB_AUTHENTIC_NAME DB_CHRONO_NAME DB_BIJOE_NAME DB_HOBO_USER DB_PASSERELLE_USER DB_COMBO_USER DB_FARGO_USER DB_WCS_USER DB_AUTHENTIC_USER DB_CHRONO_USER DB_BIJOE_USER LOG_LEVEL LOG_CHANNEL ERROR_MAIL_AUTHOR ERROR_MAIL_ADDR DOMAIN EMAIL RABBITMQ_DEFAULT_USER POSTGRES_PASSWORD DB_HOBO_PASS DB_PASSERELLE_PASS DB_COMBO_PASS DB_FARGO_PASS DB_WCS_PASS DB_AUTHENTIC_PASS RABBITMQ_DEFAULT_PASS SUPERUSER_PASS DB_PORT RABBITMQ_PORT RABBITMQ_MANAGEMENT_PORT HTTP_PORT HTTPS_PORT SMTP_HOST SMTP_PORT MAILCATCHER_HTTP_PORT PGADMIN_PORT AUTHENTIC_SUBDOMAIN COMBO_SUBDOMAIN COMBO_ADMIN_SUBDOMAIN FARGO_SUBDOMAIN HOBO_SUBDOMAIN PASSERELLE_SUBDOMAIN WCS_SUBDOMAIN CHRONO_SUBDOMAIN BIJOE_SUBDOMAIN
do
  if [ -z "${!VAR}" ]
  then
    echo "ERROR: $VAR MUST be set and MUST NOT be empty"
    err=true
  fi
done

for VAR in ENV DEBUG ALLOWED_HOSTS SMTP_USER SMTP_PASS
do
  if [ -z "${!VAR+x}" ]
  then
    echo "ERROR: $VAR MUST be set"
    err=true
  fi
done

if [ "$err" = true ]
then
  echo "***************************************************************"
  echo "ERROR: some env vars are invalid. See the error messages above."
  echo "***************************************************************"
  exit 1
fi

echo "***************************************************************"
echo "SUCCES: all env vars are set"
echo "***************************************************************" 