#!/usr/bin/env bash
# Program:
#    TODO
# History:
# 2020 JClearLove First release
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 时钟同步器
pscp -r -h /opt/ssh-scripts/pssh_servers_added.txt -l root  /var/spool/cron/root /var/spool/cron/

# 修改host

for i in $(seq 0 28); do sshpass -p Huawei12#$ pssh -H  10.0.22.$((102+i))  -i -A  -l root hostnamectl set-hostname 16c32g-centos75-00$((43+i));done;


# /etc/hosts 文件


# 配置互相免密登录
/opt/expect-scripts/nosec.sh /opt/expect-scripts/serverlist



# 配置jdk
## jdk 安装包
pscp -r -h /opt/ssh-scripts/pssh_servers_added.txt -l root /opt/jdk/ /opt
pssh -h /opt/ssh-scripts/pssh_servers_added.txt -l root -i /usr/bin/expect  /opt/expect-scripts/expect_test.sh

## jdk 环境
pscp -r -h /opt/ssh-scripts/pssh_servers_added.txt -l root /etc/profile.d/java.sh /etc/profile.d/
pssh -h /opt/ssh-scripts/pssh_servers_all.txt -l root source /etc/profile.d/java.sh

## jdk 多环境选择 -可以用expect脚本设置
update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_181/bin/java 1
update-alternatives --config java
### 使用expect选择java版本

# 复制sysctl.conf和 /etc/security/limits.conf 统计脚本queue.sh
pscp -r -h /opt/ssh-scripts/pssh_servers_added.txt -l root /etc/security/limits.conf  /etc/security/
pscp -r -h /opt/ssh-scripts/pssh_servers_added.txt -l root /etc/sysctl.conf /etc/
pssh -h /opt/ssh-scripts/pssh_servers_added.txt -i  -l root sysctl -p

pscp -r -h /opt/ssh-scripts/pssh_servers_added.txt -l root  /opt/ssh-scripts/ /opt

# server-配置jstorm
## jstorm包
pscp -r -h /opt/ssh-scripts/pssh_servers_added.txt -l root /opt/jstorm/ /opt/
## jstorm环境变量
pscp -r -h /opt/ssh-scripts/pssh_servers_added.txt -l root /etc/profile.d/jstorm.sh /etc/profile.d/
pssh -h /opt/ssh-scripts/pssh_servers_added.txt -i  -l root source /etc/profile.d/jstorm.sh

## jstorm 启动
pssh -h /opt/ssh-scripts/pssh_servers_added.txt -i  -l root  start.sh






