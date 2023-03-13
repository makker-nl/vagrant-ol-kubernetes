#!/bin/bash
SCRIPTPATH=$(dirname $0)
#
SCRIPTHOME=/vagrant/scripts
#
export KUBE_JOIN_CLUSTER_SCR=join-cluster.sh
export KUBE_JOIN_CLUSTER_SCR_TPL=$KUBE_JOIN_CLUSTER_SCR.tpl
#
echo Get Token
export KUBE_TOKEN=$(kubeadm token list | awk '/TOKEN/{getline; print}'|awk '{print $1}' )
echo Kube Token: $KUBE_TOKEN
#
echo Get CA cert hash
export KUBE_TOKEN_CA_CERT_HASH=$(openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null |    openssl dgst -sha256 -hex | sed 's/^.* //')
echo CA cert hash: $KUBE_TOKEN_CA_CERT_HASH
#
export NODE="$NODE" 
#
echo Substitute $KUBE_JOIN_CLUSTER_SCR_TPL to $KUBE_JOIN_CLUSTER_SCR
envsubst < $SCRIPTHOME/$KUBE_JOIN_CLUSTER_SCR_TPL > $SCRIPTHOME/$KUBE_JOIN_CLUSTER_SCR
chmod +x $SCRIPTHOME/$KUBE_JOIN_CLUSTER_SCR