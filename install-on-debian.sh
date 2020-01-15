#!/bin/sh

# Stop installation if something goes wrong (errpr code different from zero)
set -e

if [ ! -f install-on-debian.sh ]; then
        echo "Please run this script in the root of the publik installation folder"
	exit 1
fi

echo "Upgrade system"
#####################

apt-get update
apt-get dist-upgrade -y

echo "Install Docker"
#####################

# Source : https://docs.docker.com/install/linux/docker-ce/debian/#upgrade-docker-ce

apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common

curl -fsSL $1 https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) stable"

apt-get update && apt-get install -y docker-ce

# Enable docker to start some containers at startup
systemctl enable docker

echo "Install docker compose"
##############################

# Source : https://docs.docker.com/compose/install/#install-compose

curl -L $1 https://github.com/docker/compose/releases/download/1.25.0/docker-compose-`uname -s`-`uname -m` \
    -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Create publik user"
#########################

if getent passwd publik > /dev/null 2>&1; then
    echo "User publik already exists"
    mkdir -p /home/publik
    chown publik:publik /home/publik -R
    usermod publik -d /home/publik
    usermod publik -s /bin/bash
else
    useradd publik -m
    usermod publik -s /bin/bash
    usermod publik -d /home/publik

    echo "Choose publik password :"
    passwd publik
fi

# Allow publik to use docker
usermod -a -G docker publik

echo "Add some convenients tools"
#################################
# gettext -> build-essential
# make
# vim
# git

apt-get install -y build-essential gettext vim git

echo "Generate HTTPS base certificates"
#######################################

mkdir -p data/ssl

# Generate certificates if needed
if [ ! -f data/ssl/ticket.key ]; then
        openssl rand -out data/ssl/ticket.key 48
fi
if [ ! -f data/ssl/dhparam4.pem ]; then
        openssl dhparam -out data/ssl/dhparam4.pem 4096
fi

chown publik:publik data -R
