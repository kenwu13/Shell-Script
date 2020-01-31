#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

homeDir=/home/kenwu
dropboxDir=/home/kenwu/Dropbox

SrcDir[1]=${homeDir}/.ssh/config
SrcDir[2]=${homeDir}/.ssh/id_rsa
SrcDir[3]=${homeDir}/.ssh/id_rsa.pub
SrcDir[4]=${homeDir}/Bin/*

DestDir[1]=${dropboxDir}/Ken_Backup/LMDE3/LMDE3-SSH
DestDir[2]=${dropboxDir}/Ken_Backup/LMDE3/LMDE3-SSH
DestDir[3]=${dropboxDir}/Ken_Backup/LMDE3/LMDE3-SSH
DestDir[4]=${dropboxDir}/Ken_Code/Bash-Script/ezTravel/ez004716-lmde3

for cnt in $(seq 1 4)
do
	rsync --bwlimit=20000 --delete -av -e ssh ${SrcDir[${cnt}]} ${DestDir[${cnt}]}
done
