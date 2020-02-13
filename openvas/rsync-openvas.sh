#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# 2020-02-13
# For CentOS 7 Update openVAS

Name1=rsync-openvas.sh

cmd[1]=greenbone-nvt-sync 
cmd[2]=greenbone-certdata-sync
cmd[3]=greenbone-scapdata-sync

# Update OpenVAS's Data
for cnt in $(seq 1 3)
do
	${cmd[${cnt}]}
	if [ $? -eq 0 ]; then
		echo "${cmd[${cnt}]} Succeeded."
	else
		echo "${cmd[${cnt}]} Failed."
	fi
done

# Restart OpenVAS's Service
sleep 5
systemctl restart openvas-manager
sleep 5
systemctl restart openvas-scanner
sleep 5
systemctl restart gsad
