FROM nginx

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

RUN echo "deb http://ftp.debian.org/debian jessie-backports main" >> /etc/apt/sources.list.d/certbot.list

# HTTPS AUTO Let's encrypt certificates
RUN apt-get update \
	&& apt-get install -y certbot -t jessie-backports \
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
