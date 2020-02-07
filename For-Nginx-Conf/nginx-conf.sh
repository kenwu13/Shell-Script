#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# 2020-02-07
# Srv-List.txt = Host IP List
# Usage: nginx-conf [<command>]
# Available commands:
# Restart Restart Nginx's service 
# Deploy  Push new configuration change
# Restore Restore previous version
# Clear   Delete backup's file
# Search  Search Nginx config's file

name=nginx-conf.sh

User=ezadmin
SrvList=./Srv-List.txt

ezpass="@@u4u.6j;3"

RestartNginxService() {
rel=$(/bin/rpm -q --qf "%{version}" -f /etc/redhat-release | /bin/cut -d. -f1)

if [ "${rel}" = "7" ];then
    sudo /bin/systemctl restart nginx
elif [ "${rel}" = "6" ];then
    sudo /etc/init.d/nginx restart
elif [ "${rel}" = "5" ];then
    sudo /etc/init.d/nginx restart
else
    echo "No Match"
fi
}

DeployNginxConf() {
SrcDir[0]=/tmp
SrcDir[1]=/tmp

DestDir[0]=/etc/nginx/conf.d
DestDir[1]=/opt/APP/nginx/config/vhosts

for cnt in $(seq 0 1)
do
	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(ls -l ${DestDir[${cnt}]} | /bin/awk {'print $9'} | /bin/grep '.conf$'))

		for ((index=0; index<${#Array[@]}; index++));
		do
			echo "${Array[${index}]}"
			sudo /bin/cp "${DestDir[${cnt}]}"/"${Array[${index}]}"{,.bak}
			sudo /bin/cp "${SrcDir[${cnt}]}"/"${Array[${index}]}" "${DestDir[${cnt}]}"/"${Array[${index}]}"
			sudo /bin/sed -i 's/server_name\  localhost/server_name\  '"$(/bin/echo ${HOSTNAME} | /bin/cut -d . -f 1)"'.eztravel.com.tw/g' "${DestDir[${cnt}]}"/"${Array[${index}]}"
		done

	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
done
}

RestoreNginxConf() {
SrcDir[0]=/tmp
SrcDir[1]=/tmp

DestDir[0]=/etc/nginx/conf.d
DestDir[1]=/opt/APP/nginx/config/vhosts

for cnt in $(seq 0 1)
do
	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(/bin/ls -l ${DestDir[${cnt}]} | /bin/awk {'print $9'} | /bin/grep '.conf$'))

		for ((index=0; index<${#Array[@]}; index++));
		do
			echo "${Array[${index}]}"
			sudo /bin/cp "${DestDir[${cnt}]}"/"${Array[${index}]}".bak "${DestDir[${cnt}]}"/"${Array[${index}]}"
		done

	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
done
}

ClearNginxConf() {
SrcDir[0]=/tmp
SrcDir[1]=/tmp

DestDir[0]=/etc/nginx/conf.d
DestDir[1]=/opt/APP/nginx/config/vhosts

for cnt in $(seq 0 1)
do
	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(ls -l ${DestDir[${cnt}]} | /bin/awk {'print $9'} | /bin/grep '.conf$'))

		for ((index=0; index<${#Array[@]}; index++));
		do
			echo "${Array[${index}]}"
			sudo /bin/rm -rf "${SrcDir[${cnt}]}"/*.conf
			sudo /bin/rm -rf "${DestDir[${cnt}]}"/"${Array[${index}]}".bak
		done

	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
done
}

SearchNginx() {
SrcDir[0]=/tmp
SrcDir[1]=/tmp

DestDir[0]=/etc/nginx/conf.d
DestDir[1]=/opt/APP/nginx/config/vhosts

for cnt in $(seq 0 1)
do
	rel=$(/bin/rpm -q --qf "%{version}" -f /etc/redhat-release | /bin/cut -d. -f1)

	echo "Hostname:${HOSTNAME}"
	echo "OS:CentOS ${rel}"
	echo "IP:$(ip addr | grep -w inet | grep -v 127.0.0.1 | cut -d/ -f1 | awk '{print $2}' | grep 10.10)"
	echo ""

	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(ls -l ${DestDir[${cnt}]} | /bin/awk {'print $9'} | /bin/grep '.conf$'))

		for ((index=0; index<${#Array[@]}; index++));
		do
			ls "${DestDir[${cnt}]}"/"${Array[${index}]}"
		done

	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
	echo ""
done
}

case ${1} in

"Deploy")
	while read line;
	do
		SrvS[${index}]="${line}"
		index=$(expr ${index} + 1)
	done < ${SrvList}
	echo "[${index}]: ${SrvS[${index}]}"
	for ((index=0; index<${#SrvS[@]}; index++));
	do
		rsync --bwlimit=10000 -av -e ssh ./tmp/*.conf ${User}@${SrvS[$index]}:/tmp
		typeset -f DeployNginxConf | ssh -T ${User}@${SrvS[$index]} "$(cat); DeployNginxConf"
		typeset -f RestartNginxService | ssh -T ${User}@${SrvS[$index]} "$(cat); RestartNginxService"
	done
;;

"Restore")
	while read line;
	do
		SrvS[${index}]="${line}"
		index=$(expr ${index} + 1)
	done < ${SrvList}
	echo "[${index}]: ${SrvS[${index}]}"
	for ((index=0; index<${#SrvS[@]}; index++));
	do
		typeset -f RestoreNginxConf | ssh -T ${User}@${SrvS[$index]} "$(cat); RestoreNginxConf"
		typeset -f RestartNginxService | ssh -T ${User}@${SrvS[$index]} "$(cat); RestartNginxService"
	done
;;

"Clear")
	while read line;
	do
		SrvS[${index}]="${line}"
		index=$(expr ${index} + 1)
	done < ${SrvList}
	echo "[${index}]: ${SrvS[${index}]}"
	for ((index=0; index<${#SrvS[@]}; index++));
	do
		typeset -f ClearNginxConf | ssh -T ${User}@${SrvS[$index]} "$(cat); ClearNginxConf"
	done
;;

"Search")
	while read line;
	do
		SrvS[${index}]="${line}"
		index=$(expr ${index} + 1)
	done < ${SrvList}
	echo "[${index}]: ${SrvS[${index}]}"
	for ((index=0; index<${#SrvS[@]}; index++));
	do
		typeset -f SearchNginx | sshpass -p "${ezpass}" ssh -T ${User}@${SrvS[$index]} "$(cat); SearchNginx"
	done
;;

*)
	echo "Usage: nginx-conf [<command>] 
	Available commands: 
	Restart Restart Nginx's service 
	Deploy  Push new configuration change
	Restore Restore previous version
	Clear   Delete backup's file
	Search Search Nginx config's file"
	;;

esac
