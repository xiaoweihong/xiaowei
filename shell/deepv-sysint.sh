#!/bin/bash

HOSTIP=`hostname -I|cut -d ' ' -f 1`
NTPIP="172.16.1.209"
function Msg(){
        if [ $? -eq 0 ];then
          echo "$1" >>/tmp/sysinit-$(date +%F).log
        else
          echo "$1" >> /tmp/sysinit-$(date +%F)-error.log
        fi
}


function AddUser(){
	id admin >/dev/null
	if [ $? -ne 0 ];then
	   useradd -m admin
	fi
	
	echo "admin:admin123"|chpasswd admin
	
	Msg "admin用户添加成功。" 
	
}

function CheckSysVersion(){
	result=`cat /etc/*-release|grep "Ubuntu 14.04.5 LTS"|wc -l`
	
	Msg "版本Ubuntu 14.04.5 LTS正确"
	
}

function CheckSysPartion(){
	rootSize=`df -h|grep '/$'|awk '{print $2}'|awk -F 'G' '{print $1}'`
	res=`echo "$rootSize > 80"|bc`
	if [ $res -eq 1 ];then
		echo "根目录大于80G"
		Msg "更目录容量正常"
	fi
}

function SyncSysTime(){
	ntphost="$NTPIP"
	ntpdate $ntphost >/dev/null
	
	Msg "时间同步成功 `date "+%Y-%m-%d %H:%M:%S"`"
	
}


function CheckNetInfo(){
	netinfo=`ifconfig -a|egrep "eth|em"`
	netcount=`$netinfo|wc -l`
	nettype=`$netinfo|awk 'NR>1{print $1}'|cut -c 1-2`
	#if [ $netcount -eq 2 ];then
		#if [ "$nettype"x = "em"x ];then

		#elif [  "$nettype"x  =  "et"x  ]; then
				#statements
		#fi
	#fi
}

function CheckDiskInfo(){
	#diskInfoCount=`fdisk -l|grep "/dev/sdb"|wc -l`
	diskInfoCount=`ls -l /dev/sdb* |grep "/dev/sdb"|wc -l`
	if [ $diskInfoCount -ne 0 ];then
		Msg "数据盘存在,开始分区"
	else
		Msg "数据盘不存在，请检查系统"
		exit 6
	fi
}

function PartionData(){
 	DISKTYPE=`parted -l|grep /dev/sdb|awk '{print $3 }'|sed 's#[0-9]##g'|awk -F '.' '{print $2}'`
	if [ "$DISKTYPE" = "" ];then
	   DISKTYPE="TB"
	fi
	echo "磁盘类型是:$DISKTYPE"
	DISKSIZE=`parted -l|grep /dev/sdb|awk '{print $3 }'`
	if [ ! -d /data ];then
		mkdir -p /data
		Msg "/data目录创建成功。"
	else
		Msg "目录已经存在"
	fi
	CheckDiskInfo
	parted /dev/sdb mklabel gpt yes
	parted /dev/sdb unit $DISKTYPE
	parted /dev/sdb mkpart primary ext4 0 $DISKSIZE I
	parted /dev/sdb print

	sleep 3
	Msg "分区成功"
	mkfs.ext4 /dev/sdb1 
	
	Msg "数据盘格式化完成"
	

	mount /dev/sdb1 /data
	
	Msg "数据盘挂载完成"
	
	
	echo "/dev/sdb1  /data  ext4 defaults 0 0" >>/etc/fstab
	
	Msg "写入开机挂载数据目录成功。"
	

	ln -s /data /home/admin/data
	
	Msg "admin家目录下软连接创建成功。"

}

function main(){
	AddUser
	CheckSysVersion
	CheckSysPartion
	SyncSysTime
	CheckDiskInfo
	PartionData

}
main
