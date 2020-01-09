FROM julienbayle/publik:latest-base 

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL PUBLIK 
RUN apt-get update \
    && apt-get install -y --no-install-recommends passerelle \
    && rm -rf /var/lib/apt/lists/*

# CONFIGURE MODULES
RUN mkdir -p /etc/passerelle/settings.d/ 
COPY passerelle.settings.py /etc/passerelle/settings.d/custom.py

# NGINX CONF FOR PUBLIC
COPY nginx.template /etc/nginx/conf.d/passerelle.template

# USEFULL TO BE ABLE TO USE THE MANAGER 
RUN usermod passerelle -s /bin/bash

COPY start.sh stop.sh /usr/local/bin/
ENTRYPOINT ["start.sh"]

EXPOSE 8080 
CMD ["/bin/bash"]
