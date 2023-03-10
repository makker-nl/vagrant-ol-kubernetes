#!/bin/bash
#
# Script to create a OS group and user
# The script is using the file /media/sf_Stage/commonScripts/linux/common/makeOracleUser.properties to read the properties you can set, such as the password
#
SCRIPTPATH=$(dirname $0)
#SCRIPTPATH=/media/sf_Stage/commonScripts/linux/common

ENV=${1:-dev}

function prop {
    grep "${1}" $SCRIPTPATH/makeOracleUser.properties|cut -d'=' -f2
}

# We need a common group named oinstall.
echo Create group oinstall
sudo /usr/sbin/groupadd -g 2000 oinstall

#
# Create the Oracle user
echo Create the oracle user
sudo /usr/sbin/useradd -u 2000 -g oinstall -G dba oracle
echo Setting the oracle password to...
sudo sh -c "echo $(prop 'oracle.password') |passwd oracle --stdin"

#
# Add Oracle to sudoers so he can perform admin tasks
echo Add oracle user to sudo-ers.
sudo sh -c "echo 'oracle           ALL=NOPASSWD:        ALL' >> /etc/sudoers"
#
# Grant/Change onwer /app to oracle:oinstall
echo Grant /app to Oracle
sudo chown -R oracle:oinstall /app
echo Create /app/opensource
sudo mkdir -p /app/opensource
sudo chown -R oracle:oinstall /app/opensource
