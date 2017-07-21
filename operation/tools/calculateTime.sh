#!/bin/bash

source ./color.sh

calculate(){                                                           
    TIME_DISTANCE=$(($2-$1))
    hour_remainder=$(expr ${TIME_DISTANCE} % 3600)   
    min_distance=$(expr ${hour_remainder} / 60)    
    min_remainder=$(expr ${hour_remainder} % 60)   

    Echo_Yellow "项目部署完毕,共耗时$min_distance分$min_remainder秒"
}

START_TIME=$(date +%s)
make
END_TIME=$(date +%s)

calculate $START_TIME $END_TIME
