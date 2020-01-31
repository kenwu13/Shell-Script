#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

User=root
SrvName=10.10.8.153
SrcDir[0]=/usr/local/ansible-playbook/install/hosts
SrcDir[1]=/home/kenwu/Dropbox/Ken_Code/Bash-Script/ezTravel/ansible-t01/ansible/hosts
SrcDir[2]=/etc/ansible/*
SrcDir[3]=/root/Bin/*
SrcDir[4]=/root/Docker/*
SrcDir[5]=/root/k8s/*

DestDir[0]=/home/kenwu/Dropbox/Ken_Code/Bash-Script/ezTravel/ansible-t01/ansible/hosts
DestDir[1]=/etc/ansible/hosts
DestDir[2]=/home/kenwu/Dropbox/Ken_Code/Bash-Script/ezTravel/ansible-t01/ansible
DestDir[3]=/home/kenwu/Dropbox/Ken_Code/Bash-Script/ezTravel/ansible-t01/Bin
DestDir[4]=/home/kenwu/Dropbox/Ken_Code/Bash-Script/ezTravel/ansible-t01/Docker
DestDir[5]=/home/kenwu/Dropbox/Ken_Code/Bash-Script/ezTravel/ansible-t01/kubernetes

# Rsync ansible-p01 all's data
for cnt in 0
do
	rsync --bwlimit=20000 --delete -av -e ssh ezadmin@10.10.8.152:${SrcDir[${cnt}]} ${DestDir[${cnt}]} 
done

for cnt in 1
do
	rsync --bwlimit=20000 --delete -av -e ssh ${SrcDir[${cnt}]} ${User}@${SrvName}:${DestDir[${cnt}]}
done

for cnt in $(seq 2 5)
do
	rsync --bwlimit=20000 --delete -av -e ssh ${User}@${SrvName}:${SrcDir[${cnt}]} ${DestDir[${cnt}]}
done

