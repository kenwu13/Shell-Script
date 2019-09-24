#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Name1=rsync-openvas.sh

cmd[1]=greenbone-nvt-sync
cmd[2]=greenbone-certdata-sync
cmd[3]=greenbone-scapdata-sync

LogDir=/root/Log

for cnt in $(seq 1 3)
do
	${cmd[${cnt}]}
	if [ $? -eq 0 ]; then
		echo "${cmd[${cnt}]} Succeeded."
	else
		echo "${cmd[${cnt}]} Failed."
	fi
done

systemctl restart openvas-manager
systemctl restart openvas-scanner
