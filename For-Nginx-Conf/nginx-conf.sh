#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH 
#====================================================================
# 2020-03-05
# Srv-List.txt = Host IP List
# Usage: nginx-conf [<command>]
# Available commands:
# Restart - Restart Nginx's service 
# Deploy  - Push new configuration change
# Restore - Restore previous version
# Clear   - Delete backup's file
# Search  - Search Nginx config's file
# Chown   - Chown Nginx config's file
#====================================================================

name=nginx-conf.sh

User=
SrvList=./Srv-List.txt

ezpass=''

RestartNginxService() {
ezpass=$1
rel=$(/bin/rpm -q --qf "%{version}" -f /etc/redhat-release | /bin/cut -d. -f1)

if [ "${rel}" = "7" ];then
    echo "${ezpass}" | sudo -S /bin/systemctl restart nginx
elif [ "${rel}" = "6" ];then
    echo "${ezpass}" | sudo -S /etc/init.d/nginx restart
elif [ "${rel}" = "5" ];then
    echo "${ezpass}" | sudo -S /etc/init.d/nginx restart
else
    echo "No Match"
fi
}

DeployNginxConf() {
ezpass=$1
SrcDir[0]=/tmp
SrcDir[1]=/tmp
SrcDir[2]=/tmp
SrcDir[3]=/tmp
DestDir[0]=/etc/nginx
DestDir[1]=/etc/nginx/conf.d
DestDir[2]=/opt/APP/nginx/config
DestDir[3]=/opt/APP/nginx/config/vhosts

for cnt in $(seq 0 3)
do
	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(ls ${DestDir[${cnt}]} | /bin/grep '.conf$'))

		for ((index=0; index<${#Array[@]}; index++));
		do
			echo "${Array[${index}]}"
			echo "${ezpass}" | sudo -S /bin/cp "${DestDir[${cnt}]}"/"${Array[${index}]}"{,.bak}
			echo "${ezpass}" | sudo -S /bin/cp "${SrcDir[${cnt}]}"/"${Array[${index}]}" "${DestDir[${cnt}]}"/"${Array[${index}]}"
			echo "${ezpass}" | sudo -S /bin/sed -i 's/server_name\  localhost/server_name\  '"$(/bin/echo ${HOSTNAME} | /bin/cut -d . -f 1)"'.eztravel.com.tw/g' "${DestDir[${cnt}]}"/"${Array[${index}]}"
		done
	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
done
}

RestoreNginxConf() {
ezpass=$1
SrcDir[0]=/tmp
SrcDir[1]=/tmp
SrcDir[2]=/tmp
SrcDir[3]=/tmp
DestDir[0]=/etc/nginx/
DestDir[1]=/etc/nginx/conf.d
DestDir[2]=/opt/APP/nginx/config
DestDir[3]=/opt/APP/nginx/config/vhosts

for cnt in $(seq 0 3)
do
	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(ls ${DestDir[${cnt}]} | /bin/grep '.conf$'))

		for ((index=0; index<${#Array[@]}; index++));
		do
			echo "${Array[${index}]}"
			echo "${ezpass}" | sudo -S /bin/cp "${DestDir[${cnt}]}"/"${Array[${index}]}".bak "${DestDir[${cnt}]}"/"${Array[${index}]}"
		done
	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
done
}

ClearNginxConf() {
ezpass=$1
SrcDir[0]=/tmp
SrcDir[1]=/tmp
SrcDir[2]=/tmp
SrcDir[3]=/tmp
DestDir[0]=/etc/nginx/
DestDir[1]=/etc/nginx/conf.d
DestDir[2]=/opt/APP/nginx/config
DestDir[3]=/opt/APP/nginx/config/vhosts

for cnt in $(seq 0 3)
do
	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(ls ${DestDir[${cnt}]} | /bin/grep '.conf$'))

		for ((index=0; index<${#Array[@]}; index++));
		do
			echo "${Array[${index}]}"
			echo "${ezpass}" | sudo -S /bin/rm -rf "${SrcDir[${cnt}]}"/*.conf
			echo "${ezpass}" | sudo -S /bin/rm -rf "${DestDir[${cnt}]}"/"${Array[${index}]}".bak
		done
	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
done
}

SearchNginx() {
ezpass=$1
rel=$(/bin/rpm -q --qf "%{version}" -f /etc/redhat-release | /bin/cut -d. -f1)
SrcDir[0]=/tmp
SrcDir[1]=/tmp
SrcDir[2]=/tmp
SrcDir[3]=/tmp
DestDir[0]=/etc/nginx/
DestDir[1]=/etc/nginx/conf.d
DestDir[2]=/opt/APP/nginx/config
DestDir[3]=/opt/APP/nginx/config/vhosts

echo "Hostname:${HOSTNAME}"
echo "OS:CentOS ${rel}"
echo "IP:$(ip addr | grep -w inet | grep -v 127.0.0.1 | cut -d/ -f1 | awk '{print $2}' | grep 10.10)"
echo ""

for cnt in $(seq 0 3)
do
	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(ls ${DestDir[${cnt}]} | /bin/grep '.conf$'))
		for ((index=0; index<${#Array[@]}; index++));
		do
			/bin/ls -l "${DestDir[${cnt}]}"/"${Array[${index}]}"
		done
	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
done
}

ChownNginx() {
ezpass=$1
rel=$(/bin/rpm -q --qf "%{version}" -f /etc/redhat-release | /bin/cut -d. -f1)
SrcDir[0]=/tmp
SrcDir[1]=/tmp
SrcDir[2]=/tmp
SrcDir[3]=/tmp
DestDir[0]=/etc/nginx/
DestDir[1]=/etc/nginx/conf.d
DestDir[2]=/opt/APP/nginx/config
DestDir[3]=/opt/APP/nginx/config/vhosts

echo "Hostname:${HOSTNAME}"
echo "OS:CentOS ${rel}"
echo "IP:$(ip addr | grep -w inet | grep -v 127.0.0.1 | cut -d/ -f1 | awk '{print $2}' | grep 10.10)"
echo ""

for cnt in $(seq 0 3)
do
	if [ -d "${DestDir[${cnt}]}" ]; 
	then
		Array=($(ls ${DestDir[${cnt}]} | /bin/grep '.conf$'))
		for ((index=0; index<${#Array[@]}; index++));
		do
			echo "${ezpass}" | sudo -S /bin/chown -R ezadmin.root "${DestDir[${cnt}]}"
			/bin/ls -l "${DestDir[${cnt}]}"/"${Array[${index}]}"
			/bin/ls -l "${DestDir[${cnt}]}"
		done
	else
		echo "${DestDir[${cnt}]} does not exists."
	fi
done
}

case ${1} in

"Restart")
	while read line;
	do
		SrvS[${index}]="${line}"
		index=$(expr ${index} + 1)
	done < ${SrvList}
	echo "[${index}]: ${SrvS[${index}]}"
	for ((index=0; index<${#SrvS[@]}; index++));
	do
		sshpass -p "${ezpass}" \
		ssh -t ${User}@${SrvS[$index]} "$(declare -f RestartNginxService);RestartNginxService '${ezpass}'"
	done
;;

"Deploy")
	while read line;
	do
		SrvS[${index}]="${line}"
		index=$(expr ${index} + 1)
	done < ${SrvList}
	echo "[${index}]: ${SrvS[${index}]}"
	for ((index=0; index<${#SrvS[@]}; index++));
	do
		sshpass -p "${ezpass}" \
		rsync --bwlimit=10000 -av -e ssh ./tmp/*.conf ${User}@${SrvS[$index]}:/tmp
		sshpass -p "${ezpass}" \
		ssh -t ${User}@${SrvS[$index]} "$(declare -f DeployNginxConf);DeployNginxConf '${ezpass}'"
		sshpass -p "${ezpass}" \
		ssh -t ${User}@${SrvS[$index]} "$(declare -f RestartNginxService);RestartNginxService '${ezpass}'"
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
		sshpass -p "${ezpass}" \
		ssh -t ${User}@${SrvS[$index]} "$(declare -f RestoreNginxConf);RestoreNginxConf '${ezpass}'"
		sshpass -p "${ezpass}" \
		ssh -t ${User}@${SrvS[$index]} "$(declare -f RestartNginxService);RestartNginxService '${ezpass}'"
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
		sshpass -p "${ezpass}" \
		ssh -t ${User}@${SrvS[$index]} "$(declare -f ClearNginxConf);ClearNginxConf '${ezpass}'"
	done
;;

"Search")
	while read line;
	do
		SrvS[${index}]="${line}"
		index=$(expr ${index} + 1)
	done < ${SrvList}
	for ((index=0; index<${#SrvS[@]}; index++));
	do
		echo "======================================================================================="
		echo "${SrvS[${index}]}"
		sshpass -p "${ezpass}" \
		ssh -t ${User}@${SrvS[$index]} "$(declare -f SearchNginx);SearchNginx '${ezpass}'"
	done
;;

"Chown")
	while read line;
	do
		SrvS[${index}]="${line}"
		index=$(expr ${index} + 1)
	done < ${SrvList}
	for ((index=0; index<${#SrvS[@]}; index++));
	do
		echo "======================================================================================="
		echo "${SrvS[${index}]}"
		sshpass -p "${ezpass}" \
		ssh -t ${User}@${SrvS[$index]} "$(declare -f ChownNginx);ChownNginx '${ezpass}'"
	done
;;

*)
	echo "Usage: nginx-conf [<command>] 
	Available commands: 
	Restart - Restart Nginx's service 
	Deploy  - Push new configuration change
	Restore - Restore previous version
	Clear   - Delete backup's file
	Search  - Search Nginx config's file
	Chown   - Chown Nginx config's file"
;;

esac
