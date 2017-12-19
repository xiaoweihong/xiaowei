#!/bin/bash
basedir=$(cd $(dirname $0); pwd)
ftp_dir="/home/admin/upload_videos"

#check if user is root
if [ $(id -u) != "0" ];then
    echo "Error: You must be root to run this script!"
    exit 1
fi
apt-get install -y vsftpd db-util
echo "begin copy config files..."
cp /etc/vsftpd.conf /etc/vsftpd.conf_ori && \                                                       
cp -f ${basedir}/pam.d/vsftpd /etc/pam.d/vsftpd && \
cp -rf ${basedir}/config/* /etc/ 
if [ $? -eq 0 ];then
   echo "config files copy successful"
else
   echo "config files copy failure"
   exit
fi
sleep 1  

if [ -d $ftp_dir ];then
   echo "ftp_dir is not exist,begin to create..."
   mkdir -p $ftp_dir
fi
chown ftp $ftp_dir
service vsftpd restart
sleep 1
result=`netstat -lntup|awk '{print $4}'|awk -F ':' '{print $2}'|grep '^21$'|wc -l`
if [ $reuslt -eq 1 ];then
   echo "###################################"
   echo "vsftpd service create successful..."
   echo "default ftp dir:$ftp_dir"
   echo "default ftp user:    upload_videos"
   echo "default ftp password:upload_videos"
   echo "writen by hongxiaowei 2017-12-19 v1.0"
   echo "###################################"
else
   echo "vsftpd service create failure...."
   exit
fi
