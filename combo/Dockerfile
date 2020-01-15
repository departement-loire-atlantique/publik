FROM julienbayle/publik:latest-base

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL COMBO
# python3-django and python3-cryptography backports needed for combo
RUN apt-get update
RUN apt-get -t stretch-backports install -y --no-install-recommends python3-django python3-cryptography
RUN apt-get install -y --no-install-recommends postgresql-
# See https://dev.entrouvert.org/issues/38997
RUN apt-get install -y --no-install-recommends python3-xstatic-roboto-fontface=0.4.3.2-1
RUN apt-get install -y --no-install-recommends combo
RUN apt-get install -y --no-install-recommends publik-base-theme
RUN rm -rf /var/lib/apt/lists/*

# COMBO CONFIG
COPY combo.settings.py /etc/combo/settings.d/custom.py
RUN cp /tmp/secret /etc/combo && chmod 755 /etc/combo/secret

# NGINX CONFIG
COPY nginx.template /etc/nginx/conf.d/combo.template

# USEFULL TO BE ABLE TO RUN THE MANAGER 
RUN usermod combo -s /bin/bash

COPY start.sh stop.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/stop.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 8080 
