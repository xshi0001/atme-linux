#!/usr/bin/env bash
# Program:
#    TODO
# History:
# 2020 JClearLove First release

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

packet_received=$(netstat -su |grep "packets received" |awk -F " " '{print $1}')
packet_received_errors=$(netstat -su |grep "packet receive errors" |awk -F " " '{print $1}')
packet_errors_unknown_port_received=$(netstat -su |grep "packets to unknown port received" |awk -F " " '{print $1}')
packet_receive_buffer_errors=$(netstat -su |grep "receive buffer errors" |awk -F " " '{print $1}')

echo $packet_received $packet_received_errors $packet_errors_unknown_port_received $ packet_receive_buffer_errors > receive_begin.txt


