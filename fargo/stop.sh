#!/bin/bash

# Fail on errors
set -eu

# Stop FARGO
service nginx stop
service fargo stop

# Stop HOBO Agent
service supervisor stop

# Pause 2 seconds
sleep 2