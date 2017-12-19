#**********************************************************
# * Author        : xiaowei
# * Email         : 403828237@qq.com
# * Last modified : 2017-10-13 10:42
# * Filename      : install.sh
# * Description   : 
# * *******************************************************
#!/bin/bash
#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script!"
    exit 1
fi
clear
echo "+----------------------------------------------------------+"
echo "|          Pureftpd config,    Written by Licess           |"
echo "+----------------------------------------------------------+"
echo "|This script is a tool to install pureftpd		         |"
echo "+----------------------------------------------------------+"
echo "|For more information please visit https://hongxiaowei.com |"
echo "+----------------------------------------------------------+"
echo "|Usage: ./install.sh                                      |"
echo "+----------------------------------------------------------+"
cur_dir=$(pwd)
action=$1
. conf/ftp.conf
. include/main.sh
#. include/init.sh
. include/colors.sh

Get_Dist_Name

Install_Pureftpd()
{
    Press_Install

    Echo_Blue "Installing dependent packages..."
    if [ "$PM" = "yum" ]; then
        yum -y install make gcc gcc-c++ gcc-g77 openssl openssl-devel
    elif [ "$PM" = "apt" ]; then
        apt-get update -y
        apt-get install -y build-essential gcc g++ make openssl libssl-dev
    fi
    Echo_Blue "Download files..."
    cd ${cur_dir}/src
    Download_Files ${Download_Mirror}/ftp/pure-ftpd/${Pureftpd_Ver}.tar.bz2 ${Pureftpd_Ver}.tar.bz2
    if [ $? -eq 0 ]; then
        echo "Download ${Pureftpd_Ver}.tar.bz2 successfully!"
    else
        Download_Files https://download.pureftpd.org/pub/pure-ftpd/releases/${Pureftpd_Ver}.tar.bz2 ${Pureftpd_Ver}.tar.bz2
    fi

    Echo_Blue "Installing pure-ftpd..."
    Tarj_Cd ${Pureftpd_Ver}.tar.bz2 ${Pureftpd_Ver}
    ./configure --prefix=/usr/local/pureftpd CFLAGS=-O2 --with-puredb --with-quotas --with-cookie --with-virtualhosts --with-diraliases --with-sysquotas --with-ratios --with-altlog --with-paranoidmsg --with-shadow --with-welcomemsg --with-throttling --with-uploadscript --with-language=english --with-rfc2640 --with-ftpwho --with-tls

    make && make install

    Echo_Blue "Copy configure files..."
    mkdir -p /usr/local/pureftpd/etc
    \cp ${cur_dir}/conf/pure-ftpd.conf /usr/local/pureftpd/etc/pure-ftpd.conf
    if [ -L /etc/init.d/pureftpd ]; then
        rm -f /etc/init.d/pureftpd
    fi
    \cp ${cur_dir}/init.d/init.d.pureftpd /etc/init.d/pureftpd
    chmod +x /etc/init.d/pureftpd
    touch /usr/local/pureftpd/etc/pureftpd.passwd
    touch /usr/local/pureftpd/etc/pureftpd.pdb

    StartUp pureftpd

    cd ..
    rm -rf ${cur_dir}/src/${Pureftpd_Ver}

	if [ ! -s /bin/pureftp ]; then
        \cp ${cur_dir}/conf/pureftp /bin/pureftp
        chmod +x /bin/pureftp
    fi

    id -u www
    if [ $? -ne 0 ]; then
        groupadd www
        useradd -s /sbin/nologin -g www www
    fi

    if [[ -s /usr/local/pureftpd/sbin/pure-ftpd && -s /usr/local/pureftpd/etc/pure-ftpd.conf && -s /etc/init.d/pureftpd ]]; then
        Echo_Blue "Starting pureftpd..."
        /etc/init.d/pureftpd start
        Echo_Green "+----------------------------------------------------------------------+"
        Echo_Green "| Install Pure-FTPd completed,enjoy it!"
        Echo_Green "| =>use command: pureftp ftp {add|list|del|show} to manage FTP users."
        Echo_Green "+----------------------------------------------------------------------+"
        Echo_Green "| For more information please visit https://hongxiaowei.com"
        Echo_Green "+----------------------------------------------------------------------+"
    else
        Echo_Red "Pureftpd install failed!"
    fi
}

Uninstall_Pureftpd()
{
    if [ ! -f /usr/local/pureftpd/sbin/pure-ftpd ]; then
        Echo_Red "Pureftpd was not installed!"
        exit 1
    fi
    echo "Stop pureftpd..."
    /etc/init.d/pureftpd stop
    echo "Remove service..."
    Remove_StartUp pureftpd
    echo "Delete files..."
    rm -f /etc/init.d/pureftpd
    rm -rf /usr/local/pureftpd
	rm -rf /bin/pureftp
    echo "Pureftpd uninstall completed."
}

if [ "${action}" = "uninstall" ]; then
    Uninstall_Pureftpd
else
	if [ -s /usr/local/pureftpd ];then
		Echo_Red "已经安装过,卸载请执行./install.sh uninstall"
		exit
	fi
    Install_Pureftpd 2>&1 | tee /root/pureftpd-install.log
fi
