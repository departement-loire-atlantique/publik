FROM julienbayle/publik:latest-base

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL CHRONO
RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql- \
    && apt-get install -y --no-install-recommends chrono \
    && apt-get install -y --no-install-recommends publik-base-theme \
    && rm -rf /var/lib/apt/lists/*

# CHRONO CONFIG
RUN mkdir -p /etc/chrono/settings.d/
COPY chrono.settings.py /etc/chrono/settings.d/loire-atlantique.py
RUN cp /tmp/secret /etc/chrono && chmod 755 /etc/chrono/secret

# NGINX CONFIG
COPY nginx.template /etc/nginx/conf.d/chrono.template

# USEFULL TO BE ABLE TO RUN THE MANAGER 
RUN usermod chrono -s /bin/bash

COPY start.sh stop.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/stop.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 8080 
