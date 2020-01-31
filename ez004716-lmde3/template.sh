#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

Date=$(date +%Y%m%d)
NowTime=$(date +%H:%M)
LogFile=

User1=
SrvName=
SrcDir=

DestDir=
ExeCmd=

# Rsync Data
rsync --bwlimit=20000 --delete -av -e ssh ${User1}@${SrvName}:${SrcDir} ${DestDir}
if [ $? -eq 0 ]; then
	echo "Succeeded." 
else 
	echo "Failed." 
fi
