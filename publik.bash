#!/bin/bash

# GRU UP : Start all GRU Publik containers
alias gru-up='docker-compose up --no-build --abort-on-container-exit'

# GRU DOWN : Turn off GRU 
alias gru-down='docker-compose down'

# GRU DEAMON : Start all GRU Publik containers as a deamon
alias gru-deamon='docker-compose down && docker-compose up --no-build -d'

# GRU UPDATE : Update container images from Docker Hub
alias gru-update='docker-compose pull'

# GRU BUILD : Update proxy and postgresql images 
alias gru-build='docker-compose build'

# GRU RESET : Remove all container date (reset container status and data)
alias gru-reset='docker-compose rm && docker volume prune'

# GRU CONNECT : Connect to a running container (gruconnect combo for example)
gru-connect() { 
	docker exec -it $1 /bin/bash 
}

# GRU STATE : Print GRU components state
function getHttpCode {
        t=`wget --spider -S "http://$1" 2>&1 | grep "HTTP/" | awk '{print $$2}'`
        echo "$2 ($1) has status $t"
}
gru-state() {
        # Hobo agent
	t=`docker exec rabbitmq rabbitmqctl list_connections | grep running | wc -l`
        if [ $t -eq 12 ]
        then
                echo "${green}Hobo agent OK for all services"
        else
                echo "ERROR: All hobo agents are not ready ($t/12)"
        fi

 	# Test service HTTP status code
	getHttpCode demarches${ENV}.${DOMAIN} combo
	getHttpCode admin-demarches${ENV}.${DOMAIN} combo_agent
	getHttpCode passerelle${ENV}.${DOMAIN} passerelle
	getHttpCode demarche${ENV}.${DOMAIN} demarches-wcs
	getHttpCode compte${ENV}.${DOMAIN} authentic
	getHttpCode documents${ENV}.${DOMAIN} fargo
	getHttpCode hobo${ENV}.${DOMAIN} hobo
}

# DOCKER CLEAN : Remove exited container and images without tag
docker-clean() {
        existedContainers=`docker ps -a | grep Exited | wc -l`;
        if [ $exitedContainers -gt 0 ]; then 
                docker ps -a | grep Exited | cut -d ' ' -f 1 | xargs docker rm;
        fi
	notagImages=`docker images | grep '<none>' | wc -l`;
        if [ $notagImages -gt 0 ]; then
                docker images | grep '<none>' | awk '{print $3}' | xargs docker rmi;
        fi
}

