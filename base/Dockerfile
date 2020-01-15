FROM debian:stretch

MAINTAINER Julien BAYLE <julien.bayle@loire-atlantique.fr>

# WGET, NGNIX, VIM, ENVSUBST, QUILT, GIT, GNUPG (For apt-key), ZIP
RUN apt-get update \
    && apt-get install -y vim gettext wget nginx-full quilt gnupg git zip \
    && rm -rf /var/lib/apt/lists/*

# APT SOURCES
RUN echo "deb http://httpredir.debian.org/debian stretch main" >> /etc/apt/sources.list \
    && echo "deb http://ftp.fr.debian.org/debian stretch-updates main" >> /etc/apt/sources.list \
    && echo "deb http://ftp.fr.debian.org/debian stretch-backports main" >> /etc/apt/sources.list \
    && echo "deb http://deb.entrouvert.org/ stretch main" >> /etc/apt/sources.list \
    && wget -q -O- https://deb.entrouvert.org/entrouvert.gpg | apt-key add -

# TIMEZONE
RUN echo "Europe/Paris" > /etc/timezone && \
    apt-get update \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="fr_FR.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=fr_FR.UTF-8
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR.UTF-8
ENV LC_ALL fr_FR.UTF-8

# THEME COMPILATION TOOLS (SASS & MAKEFILE support)
# + PYTHON PACKAGES
RUN apt-get update \
    && apt-get install -y build-essential ruby-sass \
    && apt-get install -y python-pip \
    && rm -rf /var/lib/apt/lists/*

# INSTALL HOBO AGENT (NEED DJANGO 1.11 from BACKPORTS)
RUN mkdir -p /etc/hobo-agent/settings.d 
COPY hobo-agent.settings.template /etc/hobo-agent/settings.d/broker.template
RUN apt-get update \
    && apt-get -t stretch-backports install -y python-django \
    && apt-get install -y --no-install-recommends supervisor hobo-agent \
    && rm -rf /var/lib/apt/lists/*

# COPY GLOBAL PROPERTY FILES (COMMON TO ALL PUBLIK DOCKER COMPONENTS) 
COPY secret /tmp/secret
COPY global.nginx.conf /etc/nginx/conf.d/global.conf

# Add Wait-For-it COMAND LINE (DOCKER DEPENDENCIES MANAGEMENT MADE SIMPLE)
# Add Update script (DOCKER UPDATE) 
COPY pyenv.template wait-for-it.sh update.sh subst-env.sh check-env.sh /root/
RUN chmod +x /root/*.sh

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
