#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Srv[0]=erplib
Srv[1]=activity-w01
Srv[2]=activity-w02
Srv[3]=activity-w03 
Srv[4]=car-w01
Srv[5]=car-w02
Srv[6]=etk-w01
Srv[7]=etk-w02
Srv[8]=frnpbo-w01
Srv[9]=frnpbo-w02
Srv[10]=htf-w01
Srv[11]=htf-w02
Srv[12]=htlpbo-w01
Srv[13]=htlpbo-w02
Srv[14]=htlpbo-w03
Srv[15]=htlpbo-w04
Srv[16]=htlsupplier-w01
Srv[17]=htlsupplier-w02
Srv[18]=htl-w01
Srv[19]=htl-w02
Srv[20]=htl-w03 
Srv[21]=htl-w04
Srv[22]=htl-w05
Srv[23]=ins-w01
Srv[24]=ins-w02
Srv[25]=lcc-w01
Srv[26]=lcc-w02
Srv[27]=lcc-w03
Srv[28]=lcc-w04
Srv[29]=mem-w01
Srv[30]=mem-w02
Srv[31]=mem-w03
Srv[32]=mem-w04
Srv[33]=mobileweb-w01
Srv[34]=mobileweb-w02
Srv[35]=mobileweb-w03
Srv[36]=mobileweb-w04
Srv[37]=mobileweb-w05
Srv[38]=mobileweb-w06
Srv[39]=mweb-w01
Srv[40]=mweb-w02
Srv[41]=mweb-w03
Srv[42]=mweb-w04
Srv[43]=tip-w01
Srv[44]=tip-w02
Srv[45]=tip-w03
Srv[46]=tip-w04
Srv[47]=vacation-w01
Srv[48]=vacation-w02
Srv[49]=vacation-w03
Srv[50]=vacation-w04
Srv[51]=vactapi-01
Srv[52]=vactapi-02
Srv[53]=www-f01
Srv[54]=www-f02
Srv[55]=www-f03
Srv[56]=www-f04
Srv[57]=www-f11
Srv[58]=www-f12
Srv[59]=www-f13
Srv[60]=www-w01
Srv[61]=www-w02
Srv[62]=www-w03
Srv[63]=www-w04
Srv[64]=www-w05
Srv[65]=lab

case ${1} in
"erp01")
    for cnt in 0
    do
        echo "${Srv[${cnt}]} Start exec"
        ssh -t ${Srv[${cnt}]} "sudo bash /opt/script/sync_erplib_data/01_sync_erplib_data.sh"
        echo "${Srv[${cnt}]} End exec"
        echo ""
    done
;;

"yumutils")
    for cnt in $(seq 65 65)
    do
        echo "${Srv[${cnt}]} Start exec"
        ssh -t ${Srv[${cnt}]} "sudo yum install -y yum-utils"
        echo "${Srv[${cnt}]} End exec"
        echo ""
    done
;;

"yum")
    for cnt in $(seq 65 65)
    do
        echo "${Srv[${cnt}]} Start exec"
        ssh -t ${Srv[${cnt}]} "sudo yum update -y && sudo package-cleanup --oldkernels --count=2 && sudo yum autoremove -y"
        echo "${Srv[${cnt}]} End exec"
        echo ""
    done
;;

*)
    echo "Usage ${0} { erp01 | yumutils | yum }"
    ;;
esac
