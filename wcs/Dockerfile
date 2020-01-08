FROM julienbayle/publik:latest-base

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL WCS 
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       postgresql- \
       libreoffice \
       wcs-au-quotidien \
       publik-base-theme \
    && rm -rf /var/lib/apt/lists/*

# CONFIGURE MODULES
RUN mkdir /var/lib/wcs/skeletons
ARG SETTINGS_FILE=/etc/wcs/settings.d/${INSTITUTION_NAME}.py
COPY wcs.settings.py SETTINGS_FILE
RUN envsubst '$DEBUG $ALLOWED_HOSTS $DB_WCS_PASS $DB_PORT $MAILCATCHER_SMTP_PORT' < $SETTINGS_FILE > $SETTINGS_FILE

# NGINX CONF FOR PUBLIC
COPY nginx.template /etc/nginx/conf.d/wcs.template

# This user is required to use combo-manage
RUN usermod wcs -s /bin/bash

COPY start.sh stop.sh /usr/local/bin/
ENTRYPOINT ["start.sh"]

EXPOSE 8080 
CMD ["/bin/bash"]
