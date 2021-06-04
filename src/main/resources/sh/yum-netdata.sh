#!/usr/bin/env bash
# Program:
#    TODO
# History:
# 2020 JClearLove First release

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# https://developer.aliyun.com/mirror/centos?spm=a2c6h.13651102.0.0.3e221b11tbgReA
### yum 安装 管理器安装
yum install -y yum-utils device-mapper-persistent-data lvm2

# 添加阿里云镜像
yum-config-manager \
    --add-repo \
    https://mirrors.aliyun.com/repo/Centos-7.repo

yum-config-manager \
    --add-repo \
    https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/centos/docker-ce.repo

mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
pssh -h /opt/ssh-scripts/pssh_servers_new_20.txt -l root -i sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
yum makecache
# netdata
# copy netdata
# 安装依赖
yum install -y autoconf automake curl

libuv-devel
zlib-devel
lz4-devel

gcc git

libmnl-devel libuuid-devel openssl-devel Judy-devel make nc pkgconfig python

# tmp 安装
rpm -ivh autogen-5.11.8-5.x86_64.rpm --force
#tmp linux下libuv库安装教程
# copy /etc/ld.so.conf.d/libuv.conf
# 生效 ldconfig


