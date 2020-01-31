#!/usr/bin/env bash

function stop_handler() {
  stop.sh
  exit $((128 + $1));
}

# https://docs.docker.com/compose/reference/up/
# "If the process is interrupted using SIGINT (ctrl + C) or SIGTERM, the containers are stopped, and the exit code is 0."
trap 'stop_handler 15' SIGTERM
trap 'stop_handler 2' SIGINT

start.sh

while true
do
  sleep 1
done
