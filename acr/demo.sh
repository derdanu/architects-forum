#!/bin/bash
. ../util.sh

run "clear"
cd ../www

desc "Login to Azure Container Registry"
run "docker login architectsforum.azurecr.io"
desc "Build and push the image"
run "docker build . -t architectsforum.azurecr.io/architects-forum"
run "docker push architectsforum.azurecr.io/architects-forum"

desc "Modify the image and publish it again"
run "sed -i 's/Munich/New York/' index.php"
run "docker build . -t architectsforum.azurecr.io/architects-forum"
run "docker push architectsforum.azurecr.io/architects-forum"

git checkout index.php

