#!/bin/bash
SCRIPTPATH=$(dirname $0)
NODE=$1
echo Remove node $NODE from the cluster
echo First cordon $NODE
kubectl cordon $NODE
echo Then drain $NODE
kubectl drain $NODE --force --ignore-daemonsets  --delete-emptydir-data
echo Finally, delete $NODE
kubectl delete node $NODE