#!/bin/bash
# Taken from https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/master/ubuntu/vagrant/setup-hosts.sh
echo Set up hosts file
set -e
IFNAME=$1
echo Get ip address of NIC $IFNAME
ADDRESS="$(ip -4 addr show $IFNAME | grep "inet" | head -1 |awk '{print $2}' | cut -d/ -f1)"
NETWORK=$(echo $ADDRESS | awk 'BEGIN {FS="."} ; { printf("%s.%s.%s", $1, $2, $3) }')
echo Add IP Address $ADDRESS of $IFNAME to /etc/hosts
sudo sed -e "s/^.*${HOSTNAME}.*/${ADDRESS} ${HOSTNAME} ${HOSTNAME}.local/" -i /etc/hosts
#
# Update /etc/hosts about other hosts
#echo Add other hosts to /etc/hosts
cat <<EOF |  sudo tee -a /etc/hosts
${NETWORK}.11  kubemaster-1
${NETWORK}.12  kubemaster-2
${NETWORK}.21  kubeworker-1
${NETWORK}.22  kubeworker-2
${NETWORK}.30  lb
EOF