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

generateconf demarches combo http
generateconf admin-demarches combo http
generateconf documents fargo http
generateconf compte authentic http
generateconf hobo hobo http
generateconf demarche wcs http
generateconf passerelle passerelle http

generatecertificate demarches
generatecertificate admin-demarches
generatecertificate documents
generatecertificate compte
generatecertificate hobo
generatecertificate demarche
generatecertificate passerelle

generateconf demarches combo https
generateconf admin-demarches combo https
generateconf documents fargo https
generateconf compte authentic https
generateconf hobo hobo https
generateconf demarche wcs https
generateconf passerelle passerelle https

# Start NGINX (Log on screen)
nginx -g 'daemon off;'

exec "$@"
