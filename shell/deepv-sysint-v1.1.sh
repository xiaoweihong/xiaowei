#!/bin/bash

HOSTIP=`hostname -I|cut -d ' ' -f 1`
NTPIP="172.16.1.209"

LOG_PATH="/root"
DATE_N=`date "+%Y-%m-%d %H:%M:%S"`
USER_N=`whoami`
function log_info ()
{
if [  -d $LOG_PATH  ]
then
    mkdir -p $LOG_PATH
fi 
echo "${DATE_N} ${USER_N} execute $0 [INFO] $@" >>$LOG_PATH/deepv-install.log #执行成功日志打印路径
 }

function log_error ()
{
	echo -e "\033[41;37m ${DATE_N} ${USER_N} execute $0 [ERROR] $@ \033[0m"  >>$LOG_PATH/deepv-install-error.log #执行失败日志打印路径
}

function fn_log ()  {
if [  $? -eq 0  ]
then
    log_info "$@ sucessed."
    echo -e "\033[32m $@ sucessed. \033[0m"
else  
    log_error "$@ failed."
    echo -e "\033[41;37m $@ failed. \033[0m"  
    exit 1
fi
}
#trap 'fn_log "DO NOT SEND CTR + C WHEN EXECUTE SCRIPT !!!! "'2


function AddUser(){
	id admin &>/dev/null
	log_info "add admin begin--------"

	useradd -m admin -s /bin/bash
	echo "admin:admin123"|chpasswd admin	
	fn_log "user-->admin add"
    sed -i "20a admin   ALL=(ALL:ALL) ALL" /etc/sudoers
    log_info "add admin to sudoers file"
	log_info "add admin end----------"

    
 #   id dell &>/dev/null
#	log_info "add dell begin--------"
#
#	useradd -m dell -s /bin/bash
#	echo "dell:dell@2017"|chpasswd dell	
#	log_info "user-->dell add" 
#	log_info "add dell end----------"
}

function CheckSysVersion(){
	result=`cat /etc/*-release|grep "Ubuntu 14.04.5 LTS"|wc -l`
	
	fn_log "Version Ubuntu 14.04.5 LTS "
	
}

function CheckSysPartion(){
	rootSize=`df -h|grep '/$'|awk '{print $2}'|awk -F 'G' '{print $1}'`
	res=`echo "$rootSize > 80"|bc`
	if [ $res -eq 1 ];then
		log_info "/ dictroy bigger than 80G"
		log_info "/ dictroy is correct "
	fi
}

function SyncSysTime(){
	ntphost="$NTPIP"
	ntpdate $ntphost >/dev/null
	hwclock -w
	
	fn_log "sync time"
	
}


function CheckNetInfo(){	
	nettype=`ifconfig -a|egrep "eth|em"|awk '{print $1}'|head -1`
	
cat >/etc/network/interface<EOF
auto lo
iface lo inet loopback
auto $nettype
iface $nettype inet static
address 192.168.12.12
gateway 192.168.12.254
netmask 255.255.255.0
dns-nameservers 192.168.12.1
EOF
	
}

function CheckDiskInfo(){
	#diskInfoCount=`fdisk -l|grep "/dev/sdb"|wc -l`
	diskInfoCount=`ls -l /dev/sdb* |grep "/dev/sdb"|wc -l`
	if [ $diskInfoCount -ne 0 ];then
		log_info "/dev/sdb exist,begin to parted"
	else
		log_info "/dev/sdb is not exist，please check system"
		exit 6
	fi
}

function PartionData(){
 	DISKTYPE=`parted -l|grep /dev/sdb|awk '{print $3 }'|sed 's#[0-9]##g'|awk -F '.' '{print $2}'`
	if [ "$DISKTYPE" = "" ];then
	   DISKTYPE="TB"
	fi
	log_info "volume type:$DISKTYPE"
	DISKSIZE=`parted -l|grep /dev/sdb|awk '{print $3 }'`
	if [ ! -d /data ];then
		mkdir -p /data
		fn_log "/data dictory create "
	else
		fn_log "/data dictory is exist"
	fi
	CheckDiskInfo
	parted /dev/sdb mklabel gpt yes
	parted /dev/sdb unit $DISKTYPE
	parted /dev/sdb mkpart primary ext4 0 $DISKSIZE I
	parted /dev/sdb print

	sleep 3
	fn_log "parted begin……"
	mkfs.ext4 /dev/sdb1 
	
	fn_log "data volume parted"
	

	mount /dev/sdb1 /data
	
	fn_log "data volume mount"
	
	
	echo "/dev/sdb1  /data  ext4 defaults 0 0" >>/etc/fstab
	
	fn_log "write to /etc/fstab"
	

	ln -s /data /home/admin/data
	
	fn_log "data soft link create"

}

function main(){
	SyncSysTime
	AddUser
	CheckSysVersion
	CheckSysPartion
	PartionData
    CheckNetInfo
}
main
