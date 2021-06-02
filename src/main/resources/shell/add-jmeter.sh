#!/usr/bin/env bash
# Program:
#   添加jmeter服务器代码
# History:
# 2020 JClearLove First release

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH



# 配置互相免密登录
/opt/expect-scripts/nosec.sh /opt/expect-scripts/serverlist

# 时间同步
pssh -h /opt/ssh-scripts/pssh_all_servers.txt -i -l root ntpdate -u 10.0.22.34


# 配置jdk
## jdk 安装包
pscp -r -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root /opt/jdk/ /opt
## jdk 环境
pscp -r -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root /etc/profile.d/java.sh /etc/profile.d/
pssh -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root source /etc/profile.d/java.sh

## jdk 多环境选择
update-alternatives --install /usr/bin/java java /opt/jdk/jdk1.8.0_181/bin/java 1
update-alternatives --config java
### 使用expect选择java版本


# 复制sysctl.conf和 /etc/security/limits.conf
pscp -r -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root /etc/security/limits.conf  /etc/security/
pscp -r -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root /etc/sysctl.conf /etc/
pssh -h /opt/ssh-scripts/pssh_jmeter_add.txt -i  -l root sysctl -p

# jmeter
pscp -r -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root /opt/jmeter/ /opt/
pscp -r -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root /etc/profile.d/jmeter.sh /etc/profile.d/

## jmeter的属性

pssh -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root -i cat

## 测试脚本
pscp -r -h /opt/ssh-scripts/pssh_jmeter_add.txt -l root /opt/demoforshi/  /opt/



