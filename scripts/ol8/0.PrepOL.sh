#!/bin/bash
SCRIPTPATH=$(dirname $0)
# 20230104, M. van den Akker: Oracle EPEL is already in the repos.
if [ ! -f "/etc/yum.repos.d/ol8-epel.repo" ]; then
# https://techviewleo.com/how-to-enable-epel-repository-on-oracle-linux/
  echo First add OL8 developer EPEL repository
  sudo cp $SCRIPTPATH/ol8-epel.repo /etc/yum.repos.d
  sudo chmod -x /etc/yum.repos.d/ol8-epel.repo
else
  echo OL8 developer EPEL repository already added.
fi
#
echo "Installing packages required by the software (System Storage Manager and LVM)"
sudo dnf -y upgrade
sudo dnf -y install system-storage-manager lvm2
#
# Install Haveged
sudo dnf makecache
echo Install Haveged
sudo dnf -y install haveged
#
echo Disable swap for Kubernetes
sudo swapoff -a 
sudo sed -i '/ swap / s/^/#/' /etc/fstab
#
echo 'Allow PasswordAuthhentication'
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.org
sudo sed -i 's/PasswordAuthentication no/#PasswordAuthentication no/g' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo service sshd restart
