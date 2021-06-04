#!/usr/bin/env bash
# Program:
#    kafka状态检测
# History:
# 2020 JClearLove First release


PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
data=$(tail -n 3000  /opt/jstorm/jstorm-2.2.1/bin/logs/"${1}"/V2XServerSpringboot.log |grep -v "QueueRecvSize" | grep -v "RSU"|grep -v "recordCount:0"|  awk  -F ',|recordCount:|delaySum:| --' ' {print $5 / $3}' |awk '$1  {sum += $1} {num+=1} END {print sum/num}')

printf "%s\n" "$data"

