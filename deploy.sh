#!/bin/bash

mv config/database.temp.yml config/database.yml
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker build . -t notbaddays/bitpharma-api
docker push notbaddays/bitpharma-api
