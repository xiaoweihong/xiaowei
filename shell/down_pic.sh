#!/bin/bash

file_name=$1


result=`cat $file_name|cat Error.txt|awk '{print $4}'`

for i in $result
do
    wget -P /home/admin/xiaowei/scripts/pic/pics $i >/dev/null
    echo “$i 下载成功”
done
