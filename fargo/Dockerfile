FROM julienbayle/publik-docker-base 

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL PUBLIK 
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       postgresql- \
       fargo \
    && rm -rf /var/lib/apt/lists/*

# CONFIGURE MODULES
COPY fargo.settings.py /etc/fargo/settings.py
RUN cp /tmp/secret /etc/fargo
RUN chmod 755 /etc/fargo/secret

# NGINX CONF FOR PUBLIC
COPY nginx.template /etc/nginx/conf.d/fargo.template

# USEFULL TO BE ABLE TO USE THE MANAGER 
RUN usermod fargo -s /bin/bash

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8080 
CMD ["/bin/bash"]
