FROM julienbayle/publik:latest-base

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# Authentic 2 (Authentic 2 FC included)
# + MEMCACHED
# + python-attr backport needed for authentic2-multitenant

RUN apt-get update \
    && apt-get -t stretch-backports install -y python-attr \
    && apt-get install -y authentic2-multitenant postgresql- publik-base-theme memcached \
    && rm -rf /var/lib/apt/lists/*

# CONFIGURE MODULES
COPY authentic.config.py /etc/authentic2-multitenant/config.py
RUN cp /tmp/secret /etc/authentic2-multitenant
RUN chmod 755 /etc/authentic2-multitenant/secret

# CONFIGURE NGINX
COPY nginx.template /etc/nginx/conf.d/authentic.template

COPY start.sh stop.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh /usr/local/bin/stop.sh
ENTRYPOINT ["start.sh"]

EXPOSE 8080 
CMD ["/bin/bash"]
