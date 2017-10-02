#!/bin/bash
. ../util.sh

run "clear"

desc "Getting credentials for the k8s cluster"
run "az aks get-credentials --name k8sukwest --resource-group AKS"
run "kubectl config set-cluster k8sukwest --insecure-skip-tls-verify=true"

desc "Deploying stuff on the cluster"
run "cat deployment.yaml"
run "kubectl create -f deployment.yaml"
run "kubectl get svc"

ip=$(kubectl get svc architects-forum  -o json | jq .status.loadBalancer.ingress[0].ip)
while [[ "${ip}" == "null" ]]; do
  ip=$(kubectl get svc architects-forum  -o json | jq .status.loadBalancer.ingress[0].ip)
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
run "kubectl get pods -o wide"

pod=$(kubectl get pods -o json | jq .items[0].metadata.name)

run "kubectl delete pod ${pod}"
run "kubectl get pods -o wide"

run "kubectl scale deployment architects-forum-deployment --replicas=10"
run "kubectl get pods -o wide"
run "kubectl get pods -o wide"

run "az group delete --name AKS --no-wait"
