FROM julienbayle/publik:latest-base

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL WCS 
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       postgresql- \
       libreoffice \
       wcs-au-quotidien \
       publik-base-theme \
       python3-dns \
    && rm -rf /var/lib/apt/lists/*

# CONFIGURE MODULES
RUN mkdir -p /var/lib/wcs/skeletons
COPY wcs.settings.py /etc/wcs/settings.d/loire-atlantique.py

# NGINX CONF FOR PUBLIC
COPY nginx.template /etc/nginx/conf.d/wcs.template

# This user is required to use combo-manage
RUN usermod wcs -s /bin/bash

COPY start.sh stop.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/stop.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 8080 
