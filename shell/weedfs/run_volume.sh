#!/bin/bash

dataDir=$1
master=$2
port=$3

if [ "$dataDir" == "" ]; then
    dataDir="./volumn"
fi

if [ "$master" == "" ]; then
    master="localhost:9333"
fi

if [ ! -d "$dataDir" ]; then
    mkdir -p "$dataDir"
fi

IP=`hostname -I | cut -f1 -d' '`
ulimit -n 65536
./weed volume -mserver="$master" -ip=$IP -dir="$dataDir" -max=55 -port=$port -read.redirect=true
#./weed volume -mserver="$master" -dir="$dataDir" -index=leveldb -max=100 -port=$port -read.redirect=true 


