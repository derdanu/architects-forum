#!/bin/bash
. ./util.sh

run "clear"

desc "Create an AKS (Azure Kubernetes Service)"
run "az group create --name AKS --location ukwest"
run "az aks create --name k8sukwest --resource-group AKS --location ukwest --generate-ssh-keys"

desc "Getting credentials for the k8s cluster"
run "az aks get-credentials --name k8sukwest --resource-group AKS"
run "kubectl config set-cluster k8sukwest --insecure-skip-tls-verify=true"

desc "Deploying stuff on the cluster"
run "cat aks/deployment.yaml"
run "kubectl create -f aks/deployment.yaml"

run "az group delete --name AKS"
