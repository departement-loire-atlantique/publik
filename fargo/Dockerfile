FROM julienbayle/publik:latest-base 

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# INSTALL FARGO 
# + python3 backports needed for fargo
RUN apt-get update \
    && apt-get -t stretch-backports install -y python3-django python3-django-mellon python3-django-filters \
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

COPY start.sh stop.sh /usr/local/bin/
ENTRYPOINT ["start.sh"]

EXPOSE 8080 
CMD ["/bin/bash"]
