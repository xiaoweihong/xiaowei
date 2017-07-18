#!/bin/bash

#Date/Time
CDATE=$(date "+%Y-%m-%d")
CTIME=$(date "+%Y-%m-%d-%H-%M")

#Shell
CODE_DIR="/deploy/code/demo"
CONFIG_DIR="/deploy/config"
TMP_DIR="/deploy/temp"
TAR_DIR="/deploy/tar"


usage(){
	echo $"Usage: $0 [ deploy | rollback-list | rollback-pro ver]"
}

git_pro(){
	echo "begin git pull"
	cd $CODE_DIR && git pull
	API_VERL=$(git show|grep commit|cut -d " " -f2)
	API_VER=$(echo ${API_VERL:0:6})
	cp -r "$CODE_DIR" "$TMP_DIR"
}

config_pro(){
	echo "add pro config"
	/bin/cp "$CONFIG_DIR"/* $TMP_DIR/demo/
	TAR_VER="$API_VER"_"$CTIME"
	cd $TMP_DIR && mv demo pro_demo_"$TAR_VER"
}

tar_pro(){
	echo "tar pro"
	cd $TMP_DIR && tar cf pro_demo_"$TAR_VER".tar.gz pro_demo_"$TAR_VER"
	echo "tar end pro_demo_"$TAR_VER".tar.gz"
}

scp_pro(){
	echo "begin cp"
	/bin/cp $TMP_DIR/pro_demo_"$TAR_VER".tar.gz /tmp
}

deploy_pro(){
	echo "begin deploy"
	cd /tmp && tar xf pro_demo_"$TAR_VER".tar.gz
	rm -f /var/www/html/demo
	ln -s /tmp/pro_demo_"$TAR_VER" /var/www/html/demo
}

test_pro(){
	echo "test begin"
	echo "test ok"
}
rollback_list(){
	ls -l /tmp/*.tar.gz 
}

rollback_pro(){
	rm -f /var/www/html/demo
	ln -s /tmp/$1 /var/www/html/demo
}

main(){
	case $1 in
		deploy)
			git_pro;
			config_pro;
			tar_pro;
			scp_pro;
			deploy_pro;
			test_pro;
			;;
		rollback-list)
			rollback_list;
			;;
		rollback-pro)
			rollback_pro $2
			;;
		*)
		usage;
	esac
}
main $1 $2
