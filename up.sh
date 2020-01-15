#!/bin/bash

chmod +x base/check-env.sh
./base/check-env.sh

docker-compose up --no-build --abort-on-container-exit
