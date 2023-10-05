#!/bin/bash
# From: https://www.howtogeek.com/devops/how-to-start-a-kubernetes-cluster-from-scratch-with-kubeadm-and-kubectl/
SCRIPTPATH=$(dirname $0)
echo Join $(hostname) to kubemaster-1 with token kgw23w.y3s7xxljxvkw8i86 and CA cert hash:  e40dcb6838530213537e2a436d158b84a064ea496aba6fcc910d2b9ea5733272
sudo kubeadm join kubemaster-1:6443 \
    --node-name $(hostname) \
    --token kgw23w.y3s7xxljxvkw8i86 \
    --discovery-token-ca-cert-hash sha256:e40dcb6838530213537e2a436d158b84a064ea496aba6fcc910d2b9ea5733272 \
    --cri-socket unix:///run/cri-dockerd.sock
