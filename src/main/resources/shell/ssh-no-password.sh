#!/bin/bash
#说明：检查脚本所在服务器是否安装expect模块，生成IP列表中的秘钥
#将生成的秘钥id_rsa.pub传回当前服务器并标记，生成authorized_keys
#并分发到IP列表中的对应所有服务器
#使用方法：./script.sh filename
# ip列表中第一列为IP，第二列为IP对应的用户密码。列与列之间空格隔开
echo "执行检测并安装expect模块"
ep=`rpm -qa | grep expect`

if [ -z $ep   ] ; then
 echo "检测到当前服务器，没有安装expect模块，准备执行安装"
 sleep 2
 yum install -y expect

else
 echo "当前服务器已经安装expect模块，3秒后，开始执行ssh文件同步"
 sleep 3
fi
echo "读取ip列表中的IP和密码，并进行参数传递"
for row in `cat $1 | awk '{printf("%s:%s:%s\n"),$1,$2,$3}'`
  do
ip=`echo ${row} | awk -F ':' '{print $1}'`
passwd=`echo ${row} | awk -F ':' '{print $2}'`
#a=$(sed -n '$p' $1 | awk -F"," '{print $1}')
#b=$(sed -n '1!P;N;$q;D' $1 | awk -F"," '{print $1}')
echo $ip
echo $pd
echo "生成秘钥.........."

/usr/bin/expect <<-EOF
spawn ssh root@$ip ssh-keygen -t rsa
expect {
                "yes/no" { send "yes\r";exp_continue}
                "password: " {send "$passwd\r";exp_continue}
                "/root/.ssh/id_rsa" {send "\r";exp_continue}
                "empty for no passphrase" {send "\r";exp_continue}
                "again" {send "\r";exp_continue}
# ip列表中第一列为IP，第二列为IP对应的用户密码。列与列之间空格隔开
#QQ:1014353509
echo "执行检测并安装expect模块"
ep=`rpm -qa | grep expect`

if [ -z $ep   ] ; then
 echo "检测到当前服务器，没有安装expect模块，准备执行安装"
 sleep 2
 yum install -y expect

else
 echo "当前服务器已经安装expect模块，3秒后，开始执行ssh文件同步"
 sleep 3
fi
echo "读取ip列表中的IP和密码，并进行参数传递"
for row in `cat $1 | awk '{printf("%s:%s:%s\n"),$1,$2,$3}'`
  do
ip=`echo ${row} | awk -F ':' '{print $1}'`
passwd=`echo ${row} | awk -F ':' '{print $2}'`
#a=$(sed -n '$p' $1 | awk -F"," '{print $1}')
#b=$(sed -n '1!P;N;$q;D' $1 | awk -F"," '{print $1}')
echo $ip
echo $pd
echo "生成秘钥.........."

/usr/bin/expect <<-EOF
spawn ssh root@$ip ssh-keygen -t rsa
expect {
                "yes/no" { send "yes\r";exp_continue}
                "password: " {send "$passwd\r";exp_continue}
                "/root/.ssh/id_rsa" {send "\r";exp_continue}
                "empty for no passphrase" {send "\r";exp_continue}
                "again" {send "\r";exp_continue}
              }
exit
EOF
/usr/bin/expect <<-EOF
spawn scp root@$ip:~/.ssh/id_rsa.pub ~/.ssh/id_rsa.pub$ip
expect {
                "yes/no" { send "yes\r";exp_continue}
                "password: " {send "$passwd\r";exp_continue}
        }
EOF

#rm -rf /root/.ssh/id_rsa.pub
done
#获取本地IP，删除重复秘钥
ip2=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
rm -rf ~/.ssh/id_rsa.pub$ip2
echo "完成获取本地IP，删除重复秘钥操作"
cat ~/.ssh/id_rsa.pub* >> ~/.ssh/authorized_keys
echo "authorized_keys生成完毕"
#scp authorized_keys 文件到各台机器上面。
for row in `cat $1 | awk '{printf("%s:%s:%s\n"),$1,$2,$3}'`
  do
ip=`echo ${row} | awk -F ':' '{print $1}'`
passwd=`echo ${row} | awk -F ':' '{print $2}'`
echo "上传分发authorized_keys文件到"$ip"服务器"
/usr/bin/expect <<-EOF
spawn scp /root/.ssh/authorized_keys root@$ip:~/.ssh/
expect {
                "yes/no" { send "yes\r";exp_continue}
                "password: " {send "$passwd\r";exp_continue}
        }
EOF
done
echo "SSH免密码操作完毕"