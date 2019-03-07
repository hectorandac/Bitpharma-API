#!/bin/bash
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker build . -t notbaddays/bitpharma-api
docker push notbaddays/bitpharma-api
