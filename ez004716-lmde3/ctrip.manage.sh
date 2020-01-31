#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
SrcDir=./For-Ctrip-File
ezpass=

Srv[1]=ctrip-t01
Srv[2]=ctrip-t02
Srv[3]=ctrip-t03
Srv[4]=ctrip-t04
Srv[5]=ctrip-t05
Srv[6]=ctrip-t06
Srv[7]=ctrip-t07
Srv[8]=ctrip-t08
Srv[9]=ctrip-t09
Srv[10]=ctrip-t10
Srv[11]=ctrip-pgdb-t01
Srv[12]=ctrip-r01
Srv[13]=clog-t01
Srv[14]=clog-t02
Srv[15]=clog-t03
Srv[16]=clog-t04
Srv[17]=ctrip-t11

case ${1} in
"route")
    for cnt in $(seq 1 17)
    do
        echo "${Srv[${cnt}]} Start exec"
		scp ${SrcDir}/rc.local ${Srv[${cnt}]}:/tmp
        ssh -t ${Srv[${cnt}]} "echo '${ezpass}' | sudo -S /bin/cp -f /tmp/rc.local /etc/rc.d/rc.local && sudo chmod 755 /etc/rc.d/rc.local && sudo sh /etc/rc.d/rc.local && sudo route -n" 
        echo "${Srv[${cnt}]} End exec"
        echo ""
    done
;;

"host")
    for cnt in $(seq 1 17)
    do
        echo "${Srv[${cnt}]} Start exec"
		scp ${SrcDir}/hosts ${Srv[${cnt}]}:/tmp
        ssh -t ${Srv[${cnt}]} "echo '${ezpass}' | sudo -S /bin/cp -f /tmp/hosts /etc/hosts && sudo rm -rf /tmp/hosts && sudo cat /etc/hosts " 
        echo "${Srv[${cnt}]} End exec"
        echo ""
    done
;;

"repo")
    for cnt in $(seq 1 17)
    do
        echo "${Srv[${cnt}]} Start exec"
		scp ${SrcDir}/yum.repos.d/*.repo ${Srv[${cnt}]}:/tmp
        ssh -t ${Srv[${cnt}]} "sudo rm -rf /etc/yum.repos.d/* && sudo /bin/cp /tmp/*.repo /etc/yum.repos.d/ && sudo rm -rf /tmp/*.repo" 
        echo "${Srv[${cnt}]} End exec"
        echo ""
    done
;;

"chrony")
    for cnt in $(seq 1 17)
    do
        echo "${Srv[${cnt}]} Start exec"
		scp ${SrcDir}/chrony.conf ${Srv[${cnt}]}:/tmp
        ssh -t ${Srv[${cnt}]} "echo '${ezpass}' | sudo -S yum install -y chrony && sudo /bin/cp /tmp/chrony.conf /etc/chrony.conf && sudo rm -rf /tmp/chrony.conf && sudo systemctl start chronyd && sudo sysctemctl enable chronyd && chronyc -a makestep " 
        echo "${Srv[${cnt}]} End exec"
        echo ""
    done
;;

*)
    echo "Usage ${0} { route | host | repo | chrony }"
    ;;
esac
