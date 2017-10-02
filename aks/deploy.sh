#!/bin/bash
. ../util.sh

run "clear"

desc "Create an AKS (Azure Kubernetes Service)"
run "az group create --name AKS --location ukwest"
run "az aks create --name k8sukwest --resource-group AKS --location ukwest --generate-ssh-keys"

