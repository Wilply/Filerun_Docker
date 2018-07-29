#!/bin/bash

###THIS FILE IS EXECUTED ONLY IF YOUR CONTAINER IS PRIVILEGIED AND YOU SET ENV LOAD_SMB="true"
###SYNTAX :

###ADD HOSTNAME AND CREATE MOUTN DIR (uncomment the following lines):
#if [ ! -e /smbinit ]; then
  #touch /smbinit
  #echo [INFO][SMB] Create mount directory
  #mkdir /mnt/dir1 /mnt/dir2
#fi
#echo [INFO][SMB] Add hostname
#echo host_ip hostname1 hostname2 >> /etc/hosts

###MOUNT SHARES
#mount -t cifs -o username=shareuser,password=shareuserpassword,uid=abc,gid=abc //path/to/share /path/to/local
