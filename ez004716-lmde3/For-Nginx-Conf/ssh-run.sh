#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

User=KenWu
SrvList=./Srv-List.txt

while read line;
do
	SrvS[${index}]="${line}"
	index=$(expr ${index} + 1)
done < ${SrvList}

echo "[${index}]: ${SrvS[${index}]}"

for ((index=0; index<${#SrvS[@]}; index++));
do
	ssh -T ${User}@${SrvS[$index]} 'bash -s' < ./nginx-conf.sh
done
