#!/bin/bash

# Fail on errors
set -eu

# Stop NGINX
service nginx stop

# Stop MEMCACHED
service memcached stop

# Stop HOBO Agent
service supervisor stop

# Stop Authentic
service authentic2-multitenant stop

# Pause 2 seconds
sleep 2