#!/bin/bash

## Get the current date and time
dt=$(date '+%Y-%m-%d %H:%M')
## Substitute current date/time into config.toml's buildDate parameter.  Works in OSX, may need alteration in Linux?
sed -i'.bak' -e "s/buildDate = .*/buildDate = '${dt}'/" config/_default/config.toml

## Make sure we are using the current Git branch
current=`git symbolic-ref --short -q HEAD`
git checkout ${current}

## Compile the site before copying to the new image
# hugo --ignoreCache --ignoreVendor --minify --debug --verbose
hugo --ignoreCache --minify --debug --verbose
echo "Hugo compilation is complete."

## Build a new Docker image
echo "Starting docker image build..."
docker image build -f push-update-Dockerfile --no-cache -t blog-update .
echo "...docker image build is complete."

## Tag the new image and push it to Docker Hub
docker login
docker tag blog-update mcfatem/dlad-blog:latest
docker push mcfatem/dlad-blog:latest
