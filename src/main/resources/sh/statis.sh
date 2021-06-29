#!/usr/bin/env bash

pssh -h /opt/ssh-scripts/pssh50-0-25jmeters.txt -l root -i -t 0 jmeter -p /opt/demoforshi/pragram/V2XServer.properties -n -t /opt/demoforshi/pragram/500-demo.jmx
pssh -h /opt/ssh-scripts/pssh50-26-50jmeters.txt -l root -i -t 0 jmeter -p /opt/demoforshi/pragram/V2XServer.properties -n -t /opt/demoforshi/pragram/500-demo.jmx
# 0 同步服务器时间 ，一定要在部署jar包之前执行
# 0 同步服务器时间 ，一定要在部署jar包之前执行
# 0 同步服务器时间 ，一定要在部署jar包之前执行
# 0 同步服务器时间 ，一定要在部署jar包之前执行
# 0 同步服务器时间 ，一定要在部署jar包之前执行
# 0 同步服务器时间 ，一定要在部署jar包之前执行

## 确保所有服务器都能同步到
pssh -h /opt/ssh-scripts/pssh_servers_supervisors.txt -i -l root   ntpdate -u 10.0.22.34

# 1 检查zookeeper占内存情况
pssh -h /opt/ssh-scripts/pssh_servers_zk.txt -i  -l root  df -h |grep centos
#du -h --max-depth=1 清除日志
pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i  -l root  rm -rf /var/lib/zookeeper/version-2/log*
pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i  -l root  rm -rf /var/lib/zookeeper/version-2/snapshot*
# 删除jstorm 日志
pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i  -l root  rm -rf /opt/jstorm/jstorm-2.2.1/bin/logs/V*
rm -rf /var/lib/zookeeper/version-2/snapshot*

sshpass -p   Syjt_!@_3708  pscp -r  -H  $LINE   -A  -l root /opt/ssh-scripts/  /opt/


# 2 统一参数
## 2.1 统一jmeter配置参数
pscp -r -h /opt/ssh-scripts/pssh_jmeters_all.txt -l root  /opt/demoforshi/pragram/V2XServer.properties  /opt/demoforshi/pragram/
## 2.2 统一server 内核参数
pscp -r -h /opt/ssh-scripts/pssh_servers_used.txt -l root /etc/sysctl.conf /etc/
pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i  -l root sysctl -p

cat hosts | while read LINE; do sshpass -p Huawei12#$ pscp -r  -H  $LINE   -A  -l root /opt/ssh-scripts/  /opt/; done;
while read a b; do pssh -H $a -i -l root  hostnamectl set-hostname $b;done > hosts;
## 2.3 统一statis.sh的脚本
Bolt-DataHandler-STREAM_RSU

# 3 启动脚本
##200
pssh_jmeters -i -t 0 jmeter -p /opt/demoforshi/pragram/V2XServer.properties -n -t /opt/demoforshi/pragram/V2XServer-3.jmx
##500
pssh_jmeters_500  -i -t 0 jmeter -p /opt/demoforshi/pragram/V2XServer.properties -n -t /opt/demoforshi/pragram/500-demo.jmx
# 4 打jar包
# 集群部署
jstorm jar v2xbroadcasttopology-3.2.0-SNAPSHOT.jar com.cmcc.iot.v2x.transmit.V2XbroadcasttopologyApplication --exclude-jars slf4j-log4j -c \
"topology.debug.recv.tuple=false,topology.debug=false"

#10.0.22.34 查看集群测试前的cpu和mem
## mem
pssh_jmeters -i free |  awk '$1 == "Mem:" {x= $7/($3+$7)*100} $2 == "buffers/cache:" {x= $4/($3+$4)*100} $1 == "Swap:" {print x}'
## cpu
pssh_jmeters -i top -bn1 | grep "Cpu(s)" |            sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |            awk '{print 100 - $1"%"}'

# 10.0.22.11 查看集群测试前的jmeter的cpu和mem
## mem
#pssh -h /opt/ssh-scripts/pssh_servers_used.txt -l root -i  free | awk '$1 == "Mem:" {x= $7/($3+$7)*100} $2 == "buffers/cache:" {x= $4/($3+$4)*100} $1 == "Swap:" {print x}'
pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i -l root sh /opt/ssh-scripts/mem.sh
## cpu
#pssh -h /opt/ssh-scripts/pssh_servers_used.txt -l root -i top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" |  awk '{print 100 - $1"%"}'
pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i -l root sh /opt/ssh-scripts/cpu.sh

# 正式测试

##   udp端口收包之前
pssh -h /opt/ssh-scripts/pssh_servers_500_supervisors.txt -i  -l root sh /opt/ssh-scripts/receive_begin.sh

##   udp端口收包之后

##  先启动10.0.22.34上的RSU-jmeter，等启动完成稳定之后（符合频率）再执行OBU-jmeter
jmeter -n -t /opt/demoforshi/pragram/
##  bsm压力 -200万
pssh_jmeters -i -t 0 jmeter -n -t /opt/demoforshi/pragram/V2XServer.jmx
##  bsm压力 -500万
pssh_jmeters_500 -i -t 0 jmeter -n -t /opt/demoforshi/pragram/500-demo.jmx



## =========================   查看集群服务器中的日志（udpserver收包情况和延迟） -技巧：通过ip和分发的port查找日志
pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i -l root sh /opt/ssh-scripts/queue.sh V2XServerV3Topology90-68LOG-info

## =========================    统计平均时间(脚本形式)
#tail -50 /opt/jstorm/jstorm-2.2.1/bin/logs/V2XServerV3Topology1-10LOG-info/V2XServerSpringboot.log |grep -v "QueueRecvSize" | awk  -F ',
# |recordCount:|delaySum:| --' ' {print $5 / $3}'|awk '$1  {sum += $1} {num+=1} END {print sum/num}'
### 注意先复制statis.sh到所有服务器

pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i -l root sh /opt/ssh-scripts/statis.sh  V2XServerV3Topology90-68LOG-info


## 转发

pssh -h /opt/ssh-scripts/pssh_servers_used.txt -i -l root sh /opt/ssh-scripts/transfer.sh V2XServerV3Topology90-68LOG-info

## jmeter脚本处理
for ((i=1;i<=20;i++));
do
 echo "$((8080+${i})) $((8081+${i})) " >> example.txt;done;


for ((i=1;i<=20;i++)); do
 ((Num=$i %2))
  if [[ "$Num"==0 ]];   then echo "10.0.22.$((${i}/2+12))";  fi;  done

## 复制定制的jmeter脚本
for i in `seq 34 43`; do scp V2XServer-$((${i}-34)).jmx root@10.0.22.${i}:/opt/demoforshi/pragram/V2XServer-3.jmx;done;


#step1
:g/^/d|m

#step2
:v/ERROR/d

# step3 排序
:1:30sort /8\d\d\d\s]/ r


## steal%
pssh -h /opt/ssh-scripts/pssh_all_used_hosts.txt  -i   -l root  "top -bn1 | grep "^%Cpu.*st""

ps -ef | grep 'myProcessName' | grep -v grep | awk '{print $2}' | xargs -r kill -9



 pssh -h /opt/ssh-scripts/pssh50-0-25jmeters.txt -l root -i -t 0 jmeter -p /opt/demoforshi/pragram/V2XServer.properties -n -t /opt/demoforshi/pragram/500-deee.jmx & jmeter -p /opt/demoforshi/pragram/rsi.properties  -n -t /opt/demoforshi/pragram/simulator-deee.jmx


pssh -h /opt/ssh-scripts/pssh50-26-50jmeters.txt -l root -i -t 0 jmeter -p /opt/demoforshi/pragram/V2XServer.properties -n -t /opt/demoforshi/pragram/500-deee.jmx & jmeter -p /opt/demoforshi/pragram/rsi.properties  -n -t /opt/demoforshi/pragram/simulator-deee.jmx


while read a b; do  sshpass -p Clxt@2021  pssh -H ${a}  -A -i  -l root   "/opt/ssh-scripts/sedjmx.sh ${b}"; done <server-jmeter.txt;