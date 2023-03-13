#!/bin/bash
SCRIPTPATH=$(dirname $0)
echo Join $(hostname) to kubemaster-1 with token $KUBE_TOKEN and CA cert hash:  $KUBE_TOKEN_CA_CERT_HASH
sudo kubeadm join kubemaster-1:6443 \
    --node-name $(hostname) \
    --token $KUBE_TOKEN \
    --discovery-token-ca-cert-hash sha256:$KUBE_TOKEN_CA_CERT_HASH \
    --cri-socket unix:///run/cri-dockerd.sock
