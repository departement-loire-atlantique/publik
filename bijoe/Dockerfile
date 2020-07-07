FROM julienbayle/publik:latest-base

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL BIJOE
RUN apt-get update \
    && apt-get install -y --no-install-recommends postgresql- \
    && apt-get install -y --no-install-recommends bijoe \
    && apt-get install -y --no-install-recommends publik-base-theme \
    && rm -rf /var/lib/apt/lists/*

# BIJOE CONFIG
RUN mkdir -p /etc/bijoe/settings.d/
COPY bijoe.settings.py /etc/bijoe/settings.d/loire-atlantique.py
RUN cp /tmp/secret /etc/bijoe && chmod 755 /etc/bijoe/secret

# NGINX CONFIG
COPY nginx.template /etc/nginx/conf.d/bijoe.template

# USEFULL TO BE ABLE TO RUN THE MANAGER 
RUN usermod bijoe -s /bin/bash

COPY start.sh stop.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/stop.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 8080 
