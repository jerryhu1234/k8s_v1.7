#!/bin/bash
source colorecho
# centos 7.3
#安装zabbix镜像源
echo_green "安装zabbix镜像源"
yum -y install epel-release
rpm --import http://repo.zabbix.com/RPM-GPG-KEY-ZABBIX
rpm -Uv http://repo.zabbix.com/zabbix/2.4/rhel/7/x86_64/zabbix-release-2.4-1.el7.noarch.rpm
#安装mariadb源
echo_green "安装mariadb源"
if [ ! -f "/etc/yum.respos.d/MariaDB.repo" ]; then
touch /etc/yum.repos.d/MariaDB.repo
cat > /etc/yum.repos.d/MariaDB.repo<<EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF
fi
echo_green "安装依赖包及软件"
#安装依赖包
yum -y install zlib-devel mysql-devel glibc-devel curl-devel gcc automake mysql libidn-devel openssl-devel net-snmp-devel rpm-devel OpenIPMI-devel httpd mariadb-server php-gd php-mysql php-bcmath php-mbstring php-xml perl-DBI php
#安装zabbix
echo_green "安装zabbix2.4.8"
yum -y install zabbix-server-mysql zabbix-web-mysql zabbix-agent zabbix-java-gateway
systemctl restart httpd
system restart mysqld
#建库
echo_green "建库zabbix"
mysqlc=( mysql -h127.0.0.1 -uroot )
"${mysqlc[@]}" <<-EOSQL
create database if not exists zabbix character set utf8;
grant all privileges on zabbix.* to 'zabbix'@'localhost' identified by '123456';
flush privileges;
quit
EOSQL
#导入表
echo_green "导入表"
mysql -h127.0.0.1 -uzabbix -p123456 -e 'show databases'| grep zabbix &>/dev/null
if [ "$?" -eq 1 ]; then 
        mysql -h127.0.0.1 -uzabbix -p123456 zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/schema.sql
        mysql -h127.0.0.1 -uzabbix -p123456 zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/images.sql
        mysql -h127.0.0.1 -uzabbix -p123456 zabbix < /usr/share/doc/zabbix-server-mysql-2.4.8/create/data.sql
fi
#修改zabbix_server.conf
echo_green "修改配置"
sed -i '/^DBName/s/=.*$/=zabbix/' /etc/zabbix/zabbix_server.conf
sed -i '/^# DBPassword/s/.*$/DBPassword=123456/' /etc/zabbix/zabbix_server.conf
#修改zabbix_agentd.conf
#vi /etc/zabbix/zabbix_agentd.conf
#修改php.ini
sed -i 's/post_max_size = 8M/post_max_size = 32M/g' /etc/php.ini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 50M/g' /etc/php.ini
sed -i 's/;date.timezone =/date.timezone = Asia\/Shanghai/' /etc/php.ini
sed -i 's/max_execution_time = 30/max_execution_time = 600/g' /etc/php.ini
sed -i 's/max_input_time = 60/max_input_time = 600/g' /etc/php.ini
sed -i 's/memory_limit = 128M/memory_limit = 256M/g' /etc/php.ini
#配置iptables
iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
iptables-save
#开机启动
chkconfig --level 345 zabbix-server on
chkconfig --level 345 zabbix-agent on
#关selinux
setenforce 0
#启动服务
systemctl restart zabbix-server
systemctl restart zabbix-agent
echo_green "please access http://ip/zabbix!"
