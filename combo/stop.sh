#!/bin/bash

# Fail on errors
set -eu

# Stop NGINX
service nginx stop

# Stop COMBO
service combo stop

# Stop HOBO Agent
service supervisor stop

# Pause 2 seconds
sleep 2