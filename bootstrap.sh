#!/bin/sh

# Vars
export CLUSTER_NAME="bootstrap-cluster"

# Create cluster
kind create cluster --name ${CLUSTER_NAME}
# kind create cluster --config kind-settings/cluster.yml --name ${CLUSTER_NAME}

# Preload images
# https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-all-container-images-in-all-namespaces
# kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" |\
# tr -s '[[:space:]]' '\n' |\
# sort |\
# uniq > kind-settings/preloaded-images.txt 
cat kind-settings/preloaded-images.txt | xargs -I{} sh -c 'docker pull {} && kind load docker-image {} {} --name ${CLUSTER_NAME}'

# Apply infra resources (argocd, ...)
kubectl apply -k config/infra


# Do something similar for argocd?!? 
# Nginx ingress controller pre-check
# kubectl wait --namespace ingress-nginx \
#  --for=condition=ready pod \
 # --selector=app.kubernetes.io/component=controller \
  #--timeout=300s


# Apply user level applications
kubectl apply -k config/applications

# Cleanup
# kind delete cluster --name ${CLUSTER_NAME}
