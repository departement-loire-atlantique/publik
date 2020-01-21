#!/bin/sh

set -eu

docker exec authentic ls "/var/lib/authentic2-multitenant/tenants"
docker exec combo ls "/var/lib/combo/tenants"
docker exec fargo ls "/var/lib/fargo/tenants"
docker exec hobo ls "/var/lib/hobo/tenants"
docker exec passerelle ls "/var/lib/passerelle/tenants"
docker exec wcs ls "/var/lib/wcs"

echo "Installation OK"
