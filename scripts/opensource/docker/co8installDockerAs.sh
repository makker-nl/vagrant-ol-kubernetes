#!/bin/bash
SCRIPTPATH=$(dirname $0)
PROD=$1
SCRIPT_HOME=$2
SCRIPT=$SCRIPT_HOME"/co8InstallDocker.sh"
USR=$3
export DCKR_USR=$4
USER_PROPS=$SCRIPT_HOME/dockerUser.properties
USER_PROPS_TPL=$USER_PROPS.tpl
echo _______________________________________________________________________________
echo Install $PROD on Oracle Linux 8 as $USR, with Docker User: $DCKR_USR
echo . Expand $USER_PROPS_TPL to $USER_PROPS
envsubst < $USER_PROPS_TPL > $USER_PROPS
echo . Run script $SCRIPT
sudo runuser -l $USR -c $SCRIPT