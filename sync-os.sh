#!/bin/sh

set -e

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

curl -L $1 https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` \
    -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

echo "Create publik user"
#########################

if getent passwd publik > /dev/null 2>&1; then
    echo "User publik already exists"
else
    useradd publik -m
    usermod publik -s /bin/bash
    usermod publik -d /home/publik

    echo "Choose publik password"
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

echo "Add publik.bash to bash env of publik user..."
####################################################
env=`cat /home/publik/.bashrc | grep publik.bash | wc -l`
if [ $env -gt 0 ]; then
	echo "Already present"	
else
	echo "" >> /home/publik/.bashrc
	echo "source /home/publik/publik/publik.bash" >> /home/publik/.bashrc
	echo "OK"	
fi


echo "Generate HTTPS base certificates"
#######################################

mkdir -p data/ssl

# Generate certificates if needed
if [ ! -f /etc/nginx/ssl/ticket.key ]; then
        openssl rand 48 -out data/ssl/ticket.key
fi
if [ ! -f /etc/nginx/ssl/dhparam4.pem ]; then
        openssl dhparam -out data/ssl/dhparam4.pem 4096
fi

