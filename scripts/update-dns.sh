#!/bin/bash
# Taken from https://github.com/kodekloudhub/certified-kubernetes-administrator-course/blob/master/ubuntu/update-dns.sh
echo Update DNS
sudo sed -i -e 's/#DNS=/DNS=8.8.8.8/' /etc/systemd/resolved.conf
sudo service systemd-resolved restart