#!/bin/bash
Color_Text()
{ 
  echo -e " \e[0;$2m$1\e[0m"
}

Echo_Red()
{
  echo $(Color_Text "$1" "31")
}

Echo_Green()
{
  echo $(Color_Text "$1" "32")
}

Echo_Yellow()
{
  echo -n $(Color_Text "$1" "33")
}

Echo_Blue()
{
  echo $(Color_Text "$1" "34")
}
Echo_Shan()
{
  echo $(Color_Text "$1" "31;5")
}

[ -f /etc/init.d/functions ] && {
. /etc/init.d/functions
}

VERSION_NOW=`docker images|grep zlht_tomcat|awk '{print $2}'`


version(){
 clear
 Echo_Green $(date +%F)
 Echo_Yellow  "当前tomcat版本有:$VERSION_NOW"
 echo -e "\n---------------------------------------"
 Echo_Yellow "此次构建tomcat的版本是:v$1"
 echo -e "\n---------------------------------------"
}

build(){
docker build -t zlht_tomcat:v$1 -t zlht_tomcat:latest .
if [ $? -eq 0 ];then
	action "tomcat镜像构建成功"  /bin/true
fi
}

main(){
 version $1
 sleep 3
 build $1  
}

if [ $# -ne 1  ];then
	Echo_Shan "Usage $0 x.x"
    exit
fi
main $*
