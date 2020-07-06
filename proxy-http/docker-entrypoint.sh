#!/bin/bash

# Fail on errors
set -eu

# Create HTTP home
mkdir -p /home/http
chmod 777 /home/http

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

generateconf ${COMBO_SUBDOMAIN} combo http
generateconf ${COMBO_ADMIN_SUBDOMAIN} combo http
generateconf ${FARGO_SUBDOMAIN} fargo http
generateconf ${AUTHENTIC_SUBDOMAIN} authentic http
generateconf ${HOBO_SUBDOMAIN} hobo http
generateconf ${WCS_SUBDOMAIN} wcs http
generateconf ${PASSERELLE_SUBDOMAIN} passerelle http
generateconf ${CHRONO_SUBDOMAIN} chrono http

# Start NGINX (Log on screen)
nginx -g 'daemon off;'

exec "$@"
