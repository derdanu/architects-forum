#!/bin/bash
. ./util.sh

run "clear"

desc "Container Information dfalkner/architects-forum"
run "cat www/index.php"
run "cat Dockerfile"

desc "Create an ACI (Azure Container Instanace)"
run "az group create --name ACI --location westeurope"
run "az container create --name architectsforumcontainer --image dfalkner/architects-forum --resource-group ACI --ip-address public > /dev/null && az container list -o table"

ip=$(az container show --name architectsforumcontainer --resource-group ACI -o json | jq .ipAddress.ip)
while [[ "${ip}" == "null" ]]; do
  ip=$(az container show --name architectsforumcontainer --resource-group ACI -o json | jq .ipAddress.ip)
  echo "waiting for ip..."
  sleep 1
done

temp="${ip%\"}"
temp="${temp#\"}"

ip=${temp}

while ! curl -s --connect-timeout 1 ${ip} > /dev/null; do
  echo "waiting for container..."
  sleep 1
done

desc "Server is running at http://${ip}"

run "curl ${ip}"

run "az group delete --name ACI"
