#!/bin/bash

filerDir=$1
master=$2
filerPort=$3

if [ "$filerDir" == "" ]; then
    filerDir="./filer"
fi

if [ ! -d "$filerDir" ]; then
    mkdir -p "$filerDir"
fi

if [ "$master" == "" ]; then
    master="localhost:9333"
fi

if [ "$filerPort" == "" ]; then
    filerPort=8888
fi

sleep 3 # wait for a while
ulimit -n 65536
./weed filer -port=$filerPort -dir="$filerDir" -master="$master" -redirectOnRead=true -disableDirListing=false

