#!/bin/bash

masterDir=$1
masterPort=$2

IP=`hostname -I | cut -f1 -d' '`

#rm master ip config
rm -rf /home/dell/data/weedfs/master/conf

if [ "$masterDir" == "" ]; then
    masterDir="./master"
fi

if [ ! -d "$masterDir" ]; then
    mkdir -p "$masterDir"
fi

if [ "$masterPort" == "" ]; then
    masterPort=9333
fi


ulimit -n 65536
./weed master -ip=$IP -port=$masterPort -mdir="$masterDir"
