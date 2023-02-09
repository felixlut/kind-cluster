#!/bin/sh

# Vars
export CLUSTER_NAME="bootstrap-cluster"

# Cleanup
# https://kubernetes.io/docs/tasks/access-application-cluster/list-all-running-container-images/#list-all-container-images-in-all-namespaces
kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" | \
  tr -s '[[:space:]]' '\n' |\
  sort |\
  uniq >> kind-settings/preloaded-images.txt 

# Above will append all images currently in cluster, while this will remove any duplicates that already was in preloaded-images.txt
cat kind-settings/preloaded-images.txt | sort | uniq > kind-settings/preloaded-images.txt 

kind delete cluster --name ${CLUSTER_NAME}
