# Program:
#   cpu steal% statis
# History:
# 2020 JClearLove First release

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#data=$(tail -1000 /opt/jstorm/jstorm-2.2.1/bin/logs/"${1}"/V2XServerSpringboot.log |grep "] QueueRecvSize")

#mem=$(free | awk '$1 == "Mem:" {x= $7/($3+$7)*100} $2 == "buffers/cache:" {x= $4/($3+$4)*100} $1 == "Swap:" {print 100-x}')
host=$(hostname -i)

$(top | grep "^%Cpu.*st" | head -n -1)

printf "%s\n" "--- $host"
