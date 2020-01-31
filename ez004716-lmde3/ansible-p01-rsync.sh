#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

User=ezadmin
SrvName=10.10.8.152
SrcDir[0]=/home/kenwu/Dropbox/Ken_Code/Bash-Script/ezTravel/ansible-t01/ansible/roles/all
SrcDir[1]=/home/kenwu/Dropbox/Ken_Code/Bash-Script/ezTravel/ansible-t01/ansible/*.yml

DestDir[0]=/usr/local/ansible-playbook/install/roles/
DestDir[1]=/usr/local/ansible-playbook/install/

# Rsync all's data
for cnt in 0 1
do
	rsync --bwlimit=20000 --delete -av -e ssh ${SrcDir[${cnt}]} ${User}@${SrvName}:${DestDir[${cnt}]}
done
