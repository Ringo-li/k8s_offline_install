#!/bin/bash

mkdir /etc/yum.repos.d/bak && mv /etc/yum.repos.d/*.repo  /etc/yum.repos.d/bak
# cat>>/etc/yum.repos.d/ftp.repo<<EOF
# [ftp]
# name=ftp
# baseurl=file:///root/vboxsf
# gpgcheck=0
# enabled=1
# EOF
yum clean all && yum makecache
yum -y install perl gcc dkms kernel kernel-devel kernel-headers make bzip2
# 重启
mount  /root/VBoxGuestAdditions.iso  /mnt
sh /mnt/VBoxLinuxAdditions.run
mount -t vboxsf -o uid=1000,gid=1000 ansible /ansible
