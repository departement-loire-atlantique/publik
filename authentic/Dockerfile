FROM julienbayle/publik:latest-base

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# Authentic 2
# + MEMCACHED
# + python-attr backport needed for authentic2-multitenant
RUN apt-get update \
    && apt-get -t stretch-backports install -y python-attr \
    && apt-get install -y \ 
	    authentic2-multitenant \
        postgresql- \
	    publik-base-theme \
        memcached \
    && rm -rf /var/lib/apt/lists/*

# Authentic 2 - France connect module (auto installation failing)
# Cause : apt-get dependencies error for python-authentic2
RUN apt-get update \
    && sudo apt-get download python-authentic2-auth-fc \
    && mv python-authentic2-auth-fc* fc.deb \
    && dpkg -i --ignore-depends=python-authentic2 fc.deb \
    && rm fc.deb \
    && rm -rf /var/lib/apt/lists/*

# CONFIGURE MODULES
COPY authentic.config.py /etc/authentic2-multitenant/config.py
RUN envsubst '$DEBUG $ALLOWED_HOSTS $DB_AUTHENTIC_PASS $DB_PORT $RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS $RABBITMQ_PORT $ERROR_MAIL_AUTHOR $ERROR_MAIL_ADDR $MAILCATCHER_SMTP_PORT' < /etc/authentic2-multitenant/config.py > /etc/authentic2-multitenant/config.py
RUN cp /tmp/secret /etc/authentic2-multitenant
RUN chmod 755 /etc/authentic2-multitenant/secret

# CONFIGURE NGINX
COPY nginx.template /etc/nginx/conf.d/authentic.template

COPY start.sh stop.sh /usr/local/bin/
ENTRYPOINT ["start.sh"]

EXPOSE 8080 
CMD ["/bin/bash"]
