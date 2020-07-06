FROM nginx:1.17.6

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# HTTPS AUTO Let's encrypt certificates
RUN apt-get update \
	&& apt-get install -y certbot vim \
	&& rm -rf /var/lib/apt/lists/*

ADD app-http.template /etc/nginx/conf.d/ 

# TIMEZONE
RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80

CMD ["/bin/bash"]
