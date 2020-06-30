FROM nginx:1.17.6

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# HTTPS AUTO Let's encrypt certificates
RUN apt-get update \
	&& apt-get install -y certbot vim \
	&& rm -rf /var/lib/apt/lists/*

ADD *.template /etc/nginx/conf.d/ 

# TIMEZONE
RUN rm /etc/localtime \
    && ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
EXPOSE 443

CMD ["/bin/bash"]
