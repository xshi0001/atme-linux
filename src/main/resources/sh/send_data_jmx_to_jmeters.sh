#!/usr/bin/env bash
# Program:
#    TODO
# History:
# 2020 JClearLove First release
kill `jps | grep "Apache" | cut -d " " -f 1`


while read a b; do echo "two vars are: " $a $b; done < server_jmeter.txt

cat hosts | while read LINE; do sshpass -p Huawei12#$ pscp -r  -H  $LINE   -A  -l root /opt/ssh-scripts/  /opt/; done;

# data csv
while read a b; do  sshpass -p Huawei12#$ pscp -r  -H  10.0.22.$b  -A  -l root /opt/demoforshi/data/allDataCsv/$a.csv /opt/demoforshi/data/ ; done < server_jmeter.txt
# jmx
while read a b; do  sshpass -p Huawei12#$ pscp -r  -H  10.0.22.$b  -A  -l root /opt/demoforshi/pragram/allJmxs/V2XServer-3-$a.jmx /opt/demoforshi/pragram/; done < server_jmeter.txt


cd /opt/expect-scripts/ && ./nosec.sh serverlist

while read a b; do sshpass -p Huawei12#$  pssh -H $a -i -l root  hostnamectl set-hostname $b; done < newhosts.txt;
while read a b; do pssh -H ${a} -i -l root  hostnamectl set-hostname ${b}; done>hosts;

while read a b; do ssh root@${a} "hostnamectl set-hostname $b";done <hosts.txt;

while read a b; do  sshpass -p Huawei12#$  pssh -H ${b}  -A -i  -l root  sed -i.bak -e '5001,10000d' /opt/demoforshi/data/allDataCsv/$a.csv ; done < csv.txt


sed -i  "s/sssssssssssssss/${a}/g" /opt/demoforshi/pragram/500-deee.jmx  >>  /opt/ssh-scripts/sedjmx.sh

while read a b; do  sshpass -p Huawei12#$  pssh -H ${b}  -A -i  -l root   "/opt/ssh-scripts/sedjmx.sh ${a}"; done < csv.txt;
while read a b; do  sshpass -p Huawei12#$  pssh -H ${b}  -A -i  -l root   "/opt/ssh-scripts/sedjmx.sh ${a}"; done <pssh107-server-jmeter.txt;
//检查
pssh -h /opt/ssh-scripts/pssh107jmeters.txt  -l root -i tail -20 /opt/demoforshi/pragram/600-deee.jmx

#-l    远程机器的用户名
#-p    一次最大允许多少连接
#-o    输出内容重定向到一个文件
#-e    执行错误重定向到一个文件
#-t    设置命令执行的超时时间
#-A   提示输入密码并且把密码传递给ssh（注意这个参数添加后只是提示作用，随便输入或者不输入直接回车都可以，可以结合sshpass -p password使用）
#-O   设置ssh参数的具体配置，参照ssh_config配置文件
#-x   传递多个SSH 命令，多个命令用空格分开，用引号括起来
#-X   同-x 但是一次只能传递一个命令
#-i   显示标准输出和标准错误在每台host执行完毕后
#-I   读取每个输入命令，并传递给ssh进程 允许命令脚本传送到标准输入

#注:在使用工具前,确保主机间做了密钥认证,否则无法实现自动化,当然我们可以使用sshpass(yum install sshpass)配合pssh -A参数实现自动输入密码,但这要保证多台主机的密码相同,同时还要注意如果known_hosts没有信任远程主机,那么命令执行会失败,可以加上-O StrictHostKeyChecking=no参数解决,ssh能用的选项pssh也能用

# 集群刚装好系统处于原始状态，可以使用下面命令来生成其他机器的ssh秘钥并将各机器的rsa公钥添加到本机
sshpass -p password pssh -I -A -O StrictHostKeyChecking=no -h ip.txt -l brooksj -i "ssh-ketgen"  # 然后本机回车10次帮助各机器生成ssh秘钥，password为其它机器的统一密码
sshpass -p password pssh -A -O StrictHostKeyChecking=no -h ip.txt -l brooksj -i "ssh-copy-id localhost-ip" # localhost-ip改成你本机的ip

#pssh 远程批量执行命令
pssh -h ip.txt -P "uptime"
#-h  后面接主机ip文件,文件数据格式[user@]host[:port]
#-P  显示输出内容
#如果没办法密钥认证.可以采用下面方法,但不是很安全
sshpass -p 123456 pssh -A -h ip.txt -i "uptime"

#pscp 并行传输文件到远端
#传文件,不支持远程新建目录
pscp -h ip.txt test.py /tmp/dir1/
#传目录
pscp -r -h ip.txt test/ /tmp/dir1/

#prsync 并行传输文件到远端
#传文件,支持远程新建目录,即目录不存在则新建
prsync -h ip.txt test.py /tmp/dir2/
#传目录
prsync -r -h ip.txt test/ /tmp/dir3/

#pslurp从远程拉取文件到本地,在本地自动创建目录名为远程主机ip的目录,将拉取的文件放在对应主机IP目录下
#格式:pslurp -h ip.txt -L <本地目录>  <远程目录/文件>  <本地重命名>
#拉取文件
pslurp -h ip.txt -L /root/ /root/1.jpg picture
ll /root/172.16.1.13/picture
-rw-r--r-- 1 root root 148931 Jan  9 15:41 /root/172.16.1.13/picture
#拉取目录
pslurp -r -h ip.txt -L /root/ /root/test temp
ll -d /root/172.16.1.13/temp/
drwxr-xr-x 2 root root 23 Jan  9 15:49 /root/172.16.1.13/temp/

#pnuke:远程批量killall
pnuke -h ip.txt nginx


