FROM julienbayle/publik:latest-base

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL HOBO (without postgresql)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       zip \
       postgresql- \
       hobo \
       publik-base-theme \
    && rm -rf /var/lib/apt/lists/*

# COPY conf files
COPY site-options.cfg /tmp/
COPY *.template /tmp/
RUN mkdir -p /etc/hobo/settings.d/
COPY hobo.settings.py /etc/hobo/settings.d/${INSTITUTION_NAME}.py

# NGINX CONF FOR PUBLIC
COPY nginx.template /etc/nginx/conf.d/hobo.template

# This user is required to use hobo-manage
RUN usermod hobo -s /bin/bash

COPY start.sh stop.sh /usr/local/bin/
ENTRYPOINT ["start.sh"]

EXPOSE 8080 
CMD ["/bin/bash"]
