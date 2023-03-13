#!/bin/bash
SCRIPTPATH=$(dirname $0)
echo Join $(hostname) to kubemaster-1 with token j1w9sc.lxgs3gxcfrebhm5w and CA cert hash:  1dd0e9bddf219a3cf8d4b096df4de927ff22cfbe832266506bf3deff98c488cc
sudo kubeadm join kubemaster-1:6443 \
    --node-name $(hostname) \
    --token j1w9sc.lxgs3gxcfrebhm5w \
    --discovery-token-ca-cert-hash sha256:1dd0e9bddf219a3cf8d4b096df4de927ff22cfbe832266506bf3deff98c488cc \
    --cri-socket unix:///run/cri-dockerd.sock
