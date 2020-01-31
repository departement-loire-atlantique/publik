#!/bin/sh

function check() {
  container=$1
  folder=$2
  docker exec $container ls "$folder"  # Make sure folder exists
  if [ $? -ne 0 ]; then
    echo "ERROR: $folder on $container doesn't exist but should"
    exit 1
  fi
  c=`docker exec $container ls "$folder" | wc -l`
  if [ "$c" -eq "0" ]; then 
    echo "ERROR: $folder on $container is empty but shouldn't"
    exit 1
  fi
}

check authentic "/var/lib/authentic2-multitenant/tenants"
check combo "/var/lib/combo/tenants"
check fargo "/var/lib/fargo/tenants"
check hobo "/var/lib/hobo/tenants"
check passerelle "/var/lib/passerelle/tenants"
check wcs "/var/lib/wcs"

echo "Deployment looks OK"
