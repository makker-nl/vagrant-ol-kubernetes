#!/bin/bash
PROD=$1
SCRIPT=$2
USR=$3
echo _______________________________________________________________________________
echo Run Script $SCRIPT for $PROD as $USR with parameters  ${@:4}
sudo runuser -u $USR  $SCRIPT ${@:4}
