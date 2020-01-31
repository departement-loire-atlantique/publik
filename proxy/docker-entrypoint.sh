#!/bin/bash

# Fail on errors
set -eu

# Create HTTP home
mkdir -p /home/http
chmod 777 /home/http

err=false
for VAR in DOMAIN PGADMIN_PORT RABBITMQ_MANAGEMENT_PORT MAILCATCHER_HTTP_PORT EMAIL
do
  if [ -z "${!VAR}" ]
  then
    echo "ERROR: $VAR MUST be set and MUST NOT be empty"
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

# Add tools to NGINX (pgadmin, ...)
envsubst '${ENV} ${DOMAIN} ${PGADMIN_PORT} ${RABBITMQ_MANAGEMENT_PORT} ${MAILCATCHER_HTTP_PORT}' < /etc/nginx/conf.d/tools.template \
	> /etc/nginx/conf.d/tools.conf

# Create NGINX configuration for Publik containers
function generateconf() {
	export APP_URL=$1
	export APP_LINK=$2
	if [ ! -f /etc/nginx/conf.d/${APP_URL}-$3.conf ]; then
		envsubst '${APP_URL} ${APP_LINK} ${ENV} ${DOMAIN}' \
			< /etc/nginx/conf.d/app-$3.template \
			> /etc/nginx/conf.d/${APP_URL}-$3.conf
	fi
}

function generatecertificate() {
	if [ ! -d /etc/letsencrypt/live/$1${ENV}.${DOMAIN} ]; then
		service nginx start
    # https://certbot.eff.org/docs/using.html#certbot-command-line-options
		certbot certonly --webroot -n --agree-tos \
			-w /home/http \
			-d $1${ENV}.${DOMAIN} \
			--email ${EMAIL}
		service nginx stop
	fi
}

generateconf ${COMBO_SUBDOMAIN} combo http
generateconf ${COMBO_ADMIN_SUBDOMAIN} combo http
generateconf ${FARGO_SUBDOMAIN} fargo http
generateconf ${AUTHENTIC_SUBDOMAIN} authentic http
generateconf ${HOBO_SUBDOMAIN} hobo http
generateconf ${WCS_SUBDOMAIN} wcs http
generateconf ${PASSERELLE_SUBDOMAIN} passerelle http

generatecertificate ${COMBO_SUBDOMAIN}
generatecertificate ${COMBO_ADMIN_SUBDOMAIN}
generatecertificate ${FARGO_SUBDOMAIN}
generatecertificate ${AUTHENTIC_SUBDOMAIN}
generatecertificate ${HOBO_SUBDOMAIN}
generatecertificate ${WCS_SUBDOMAIN}
generatecertificate ${PASSERELLE_SUBDOMAIN}

generateconf ${COMBO_SUBDOMAIN} combo https
generateconf ${COMBO_ADMIN_SUBDOMAIN} combo https
generateconf ${FARGO_SUBDOMAIN} fargo https
generateconf ${AUTHENTIC_SUBDOMAIN} authentic https
generateconf ${HOBO_SUBDOMAIN} hobo https
generateconf ${WCS_SUBDOMAIN} wcs https
generateconf ${PASSERELLE_SUBDOMAIN} passerelle https

# Start NGINX (Log on screen)
nginx -g 'daemon off;'

exec "$@"
