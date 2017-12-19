#!/bin/bash

HOSTIP=`hostname -I|cut -d ' ' -f 1`
NTPIP="172.16.1.209"

logdateformat="$(date "+%Y-%m-%d %H:%M:%S")"

function Msg(){
    if [ $? -eq 0 ];then
      echo -e "$logdateformat\t$1" >> /root/sysinit-$(date +%F).log
    else
      echo -e "$logdateformat\t$1" >> /root/sysinit-$(date +%F)-error.log
    fi
}


function AddUser(){
	id admin &>/dev/null
	Msg "add admin begin--------"

	useradd -m admin -s /bin/bash
	echo "admin:admin123"|chpasswd admin	
	Msg "user-->admin add" 
	Msg "add admin end----------"

	id dell &>/dev/null
	Msg "add dell begin--------"

	useradd -m dell -s /bin/bash
	echo "dell:dell@2017"|chpasswd dell	
	Msg "user-->dell add" 
	Msg "add dell end----------"
}

function CheckSysVersion(){
	result=`cat /etc/*-release|grep "Ubuntu 14.04.5 LTS"|wc -l`
	
	Msg "Version Ubuntu 14.04.5 LTS "
	
}

function CheckSysPartion(){
	rootSize=`df -h|grep '/$'|awk '{print $2}'|awk -F 'G' '{print $1}'`
	res=`echo "$rootSize > 80"|bc`
	if [ $res -eq 1 ];then
		echo "/ dictroy bigger than 80G"
		Msg "/ dictroy "
	fi
}

function SyncSysTime(){
	ntphost="$NTPIP"
	ntpdate $ntphost >/dev/null
	hwclokc -w
	
	Msg "sync time"
	
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
		Msg "/dev/sdb exist,begin to parted"
	else
		Msg "/dev/sdb is not exist，please check system"
		exit 6
	fi
}

function PartionData(){
 	DISKTYPE=`parted -l|grep /dev/sdb|awk '{print $3 }'|sed 's#[0-9]##g'|awk -F '.' '{print $2}'`
	if [ "$DISKTYPE" = "" ];then
	   DISKTYPE="TB"
	fi
	echo "volume type:$DISKTYPE"
	DISKSIZE=`parted -l|grep /dev/sdb|awk '{print $3 }'`
	if [ ! -d /data ];then
		mkdir -p /data
		Msg "/data dictory create "
	else
		Msg "/data dictory is exist"
	fi
	CheckDiskInfo
	parted /dev/sdb mklabel gpt yes
	parted /dev/sdb unit $DISKTYPE
	parted /dev/sdb mkpart primary ext4 0 $DISKSIZE I
	parted /dev/sdb print

	sleep 3
	Msg "parted"
	mkfs.ext4 /dev/sdb1 
	
	Msg "data volume parted"
	

	mount /dev/sdb1 /data
	
	Msg "data volume mount"
	
	
	echo "/dev/sdb1  /data  ext4 defaults 0 0" >>/etc/fstab
	
	Msg "write to /etc/fstab"
	

	ln -s /data /home/admin/data
	
	Msg "data soft link create"

}

function main(){
	SyncSysTime
	AddUser
	CheckSysVersion
	CheckSysPartion	
	CheckDiskInfo
	PartionData
}
main
