#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

user=KenWu
name=nginx-conf.sh

User=KenWu
SrvList=./Srv-List.txt

RestartNginxService() {
rel=$(sudo /bin/rpm -q --qf "%{version}" -f /etc/redhat-release | /bin/cut -d. -f1)

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
		Array=($(sudo ls -l ${DestDir[${cnt}]} | /bin/awk {'print $9'} | /bin/grep '.conf$'))

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
		Array=($(sudo /bin/ls -l ${DestDir[${cnt}]} | /bin/awk {'print $9'} | /bin/grep '.conf$'))

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
		Array=($(sudo ls -l ${DestDir[${cnt}]} | /bin/awk {'print $9'} | /bin/grep '.conf$'))

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

*)
	echo "Usage ${0} { Deploy | Restore | Clear }"
	;;
esac
