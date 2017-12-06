#!/bin/bash

folder_path=$1

if [ $# -ne 1  ];then
    echo "Usage:./$0 folder_path"
fi

folder_result=`find $folder_path -type d|sed 1d|tac`

for i in $folder_result
do
    count=`cat /proc/sys/kernel/random/uuid| cksum | cut -f1 -d" "`
    foldname=`basename $i`
    dir_name=`dirname $i`
    cd $dir_name
    mv $foldname $count
    echo "目录$i更改$count成功"
done
file_result=`find $folder_path -type f`

for j in $file_result
do
    count=`cat /proc/sys/kernel/random/uuid| cksum | cut -f1 -d" "`
    #filename=`echo $j|awk -F '/' '{print $NF}'
    filename=`basename $j`
    cd `dirname $j` && mv $filename $count.jpg
    echo "文件$j更改$count成功"
done
