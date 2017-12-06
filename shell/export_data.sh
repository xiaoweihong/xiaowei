#!/bin/bash

VOLUME_PATH=$1
EXPORT_PATH=$2

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script!"
    exit 1
fi

if [ $# -ne 2 ];then
    echo "Usage:./$0 volume_path export_path"
    exit 1
fi

begin_time=$(date +%s)

if [ ! -d $VOLUME_PATH ];then
    echo "存储卷目录$VOLUME_PATH 不存在"
    exit 2
fi

if [ ! -d $EXPORT_PATH ];then
    echo "备份目录$EXPORT_PATH 不存在"
    exit 2
fi

cd $VOLUME_PATH
data_result=`ls -l|awk -F '[ .]+' 'NR>1 {print $9}'|uniq`
echo "需要导出文件的路径是:$VOLUME_PATH"

for i in $data_result;
do
    weed export -dir=$VOLUME_PATH -volumeId=$i -o=$EXPORT_PATH/$i.tar -fileNameFormat="{{.Key}}-{{.Name}}"
#weed export -dir=$VOLUME_PATH -volumeId=3052 -o=$EXPORT_PATH/3052.tar -fileNameFormat="{{.Key}}-{{.Name}}"
#cd $EXPORT_PATH && tar xf  $i.tar --no-same-owner
if [ $? -eq 0 ];then
#    echo "数据包$i解压成功"
     echo "导出$i成功"
fi
done

#解压目录
#cd $EXPORT_PATH/
#back_result=`ls -l|awk 'NR>1 {print $NF}'|uniq`
#for i in $back_result;
#do
#if [ "${i##*.}" = "tar" ];then
#    tar xf $i && rm -rf $i
#fi
#done
#echo "解压文件完毕"

#清理压缩文件
#rm -f *.tar
#echo "目录清理完毕"

#重命名文件
#data_result=`ls -l|awk 'NR>1 {print $NF}'|uniq`
#tag=`ls|head -1|awk -F '.' '{print $2}'`

#if [ "$tag"x = ''x ]; then
#ls |xargs -t -i mv {} {}.jpg
#echo "重命名文件成功"
#fi
end_time=$(date +%s)

#统计程序运行时间函数
calculate(){                                                           
    TIME_DISTANCE=$(($2-$1))
    hour_remainder=$(expr ${TIME_DISTANCE} % 3600)   
    min_distance=$(expr ${hour_remainder} / 60)    
    min_remainder=$(expr ${hour_remainder} % 60)   

    echo "文件导出完毕,共耗时$hour_remainder小时$min_distance分$min_remainder秒"
}

calculate $begin_time $end_time
