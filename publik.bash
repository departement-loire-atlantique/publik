#!/bin/bash

# GRU UP : Start all GRU Publik containers
alias gru-up='docker-compose up --no-build --abort-on-container-exit'

# GRU DOWN : Delete all GRU containers 
alias gru-down='docker-compose down'

# GRU START : Start GRU containers 
alias gru-start='docker-compose start'

# GRU STOP : Stop GRU containers 
alias gru-stop='docker-compose stop'

# GRU DEAMON : Start all GRU Publik containers as a deamon
alias gru-deamon='docker-compose stop && docker-compose up --no-build -d'

# GRU PULL : Pull container images from Docker Hub
alias gru-pull='docker-compose pull'

# GRU BUILD : Update proxy and postgresql images 
alias gru-build='docker-compose build'

# GRU RESET : Remove all container date (reset container status and data)
alias gru-reset='docker-compose rm && docker volume prune'

# GRU CONNECT : Connect to a running container (gru-connect combo for example)
gru-connect() { 
	docker exec -it $1 /bin/bash 
}

# GRU COOK : Start cook mecanism to initiate instance
alias gru-init='docker exec hobo /tmp/cook.sh'

# GRU UPDATE : Update packages, patches and themes
gru-update() {
	docker-compose exec authentic /root/update.sh $1
	docker-compose exec combo /root/update.sh $1
	docker-compose exec fargo /root/update.sh $1
	docker-compose exec hobo /root/update.sh $1
	docker-compose exec passerelle /root/update.sh $1
	docker-compose exec wcs /root/update.sh $1
}

# PUSH ALL PUBLIK IMAGES

gru-push-all() {
	docker push julienbayle/publik:$1-authentic
	docker push julienbayle/publik:$1-base
	docker push julienbayle/publik:$1-base
	docker push julienbayle/publik:$1-combo
	docker push julienbayle/publik:$1-fargo
	docker push julienbayle/publik:$1-hobo
	docker push julienbayle/publik:$1-passerelle
	docker push julienbayle/publik:$1-pgsql
	docker push julienbayle/publik:$1-proxy
	docker push julienbayle/publik:$1-wcs
}

# TAG ALL PUBLIK IMAGES
gru-tag-all() {
	docker tag julienbayle/publik:$1-authentic julienbayle/publik:$2-authentic
	docker tag julienbayle/publik:$1-base julienbayle/publik:$2-base
	docker tag julienbayle/publik:$1-combo julienbayle/publik:$2-combo
	docker tag julienbayle/publik:$1-fargo julienbayle/publik:$2-fargo
	docker tag julienbayle/publik:$1-hobo julienbayle/publik:$2-hobo
	docker tag julienbayle/publik:$1-passerelle julienbayle/publik:$2-passerelle
	docker tag julienbayle/publik:$1-pgsql julienbayle/publik:$2-pgsql
	docker tag julienbayle/publik:$1-proxy julienbayle/publik:$2-proxy
	docker tag julienbayle/publik:$1-wcs julienbayle/publik:$2-wcs
}

# GRU STATE : Print GRU components state
function testHttpCode {
        t=`wget --spider -S "$1" 2>&1 | grep "HTTP/" | tail -1 | awk '{print $ 2}'`
        if [ "$t" = "$3" ]; then
		echo -e "\e[42mOK\t$2 ($1) has status $t\e[0m"
	else
		echo -e "\e[41mERROR\t$2 ($1) has status $t\e[0m"
	fi
}
loadenv() {
	export $(grep -v '^#' .env | xargs)
}
gru-state() {
        loadenv
	# Hobo agent
	t=`docker exec rabbitmq rabbitmqctl list_connections | grep running | wc -l`
        if [ $t -eq 12 ]
        then
                echo -e "\e[42mOK\tHobo agent OK for all services\e[0m"
        else
                echo -e "\e[41mERROR\tAll hobo agents are not ready ($t/12)\e[0m"
        fi

	
 	# Test service HTTP status code 200
	testHttpCode https://demarches${ENV}.${DOMAIN} combo 200
	testHttpCode https://admin-demarches${ENV}.${DOMAIN} combo_agent 200
	testHttpCode https://passerelle${ENV}.${DOMAIN} passerelle 200
	testHttpCode https://demarche${ENV}.${DOMAIN} demarches-wcs 200
	testHttpCode https://compte${ENV}.${DOMAIN} authentic 200
	testHttpCode https://documents${ENV}.${DOMAIN} fargo 200
	testHttpCode https://hobo${ENV}.${DOMAIN} hobo 200
	testHttpCode http://pgadmin${ENV}.${DOMAIN}/browser/ pgadmin 200
	testHttpCode http://rabbitmq${ENV}.${DOMAIN} rabbitmanager 200
	testHttpCode http://webmail${ENV}.${DOMAIN} rabbitmanager 200
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

