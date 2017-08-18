# svn服务端搭建优化 #

## 安装及配置svn ##

1. 命令行安装
    yum install -y subversion
2. 创建根目录
    svnadmin create svnroot

3. 创建版本库及配置文件目录
    svnadmin create svnroot/project1
    svnadmin create svnroot/project2
    mkdir -p svnroot/config

4. 配置文件
    cp svnroot/project1/conf/{authz,passwd} svnroot/config
**修改project1配置文件**
    [root@docker ~]# grep  -Ev "^$|#|sasl" svnroot/project1/conf/svnserve.conf
    [general]
    anon-access = none
    auth-access = write
    password-db = ../../config/passwd
    authz-db = ../../config/authz
    realm = project1
**修改project2配置文件**
    [root@docker ~]# grep  -Ev "^$|#|sasl" svnroot/project2/conf/svnserve.conf
    [general]
    anon-access = none
    auth-access = write
    password-db = ../../config/passwd
    authz-db = ../../config/authz
    realm = project2
**密码与权限文件修改**
    [root@docker ~]# grep -v "^#" svnroot/config/passwd 
    [users]
    cheng = 123 
    tom = 123 
    jim = 123

    [root@docker ~]# grep -v "^#" svnroot/config/authz 
    [groups]
    adm = cheng 
    user = tom,jim 
    
    [project1:/] 
    @adm = rw 
    `* = r` 
    [project2:/] 
    @adm = rw 
    `* = r` 
**启动**
svnserve -d -r svnroot/
