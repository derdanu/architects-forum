#!/bin/bash
. ../util.sh

run "clear"

desc "Getting credentials for the k8s cluster"
run "az aks get-credentials --name k8sukwest --resource-group AKS"
run "kubectl config set-cluster k8sukwest --insecure-skip-tls-verify=true"

desc "Deploying stuff on the cluster"
run "cat deployment.yaml"
run "kubectl create -f deployment.yaml"

run "az group delete --name AKS --no-wait"
