#!/bin/bash

echo FILERUN DOCKERIZED BY WILPLY

if [ ! -s /scripts/firststart ]; then
  echo [INFO] Create config folder
  mkdir /app/logs /app/self_keys
  mkdir /app/logs/nginx /app/logs/php
  if [ $UID -ne 2000 ] || [ $GID -ne 2000 ]; then
    echo [INFO] UPDATE USER
    usermod -u $UID abc
    groupmod -g $GID abc
  fi
  echo [INFO] Update permission
  chown -R abc:abc /app
fi

if [ ! -s /scripts/firststart ] && $LOCAL_DB ; then
  echo [INFO] INIT MYSQL
  touch /scripts/firststart
  service mysql start
  mysql < /scripts/initdb.sql
elif $LOCAL_DB ; then
  service mysql start
fi

if [ ! -s /app/self_keys/cert.key ] || [ ! -s /app/self_keys/cert.crt ]; then
  echo [INFO] No ssl cert or key found, generate new
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /app/self_keys/cert.key -out /app/self_keys/cert.crt -subj "/C=EN/ST=Some-State/L=city/O=Internet Widgits Pty Ltd/OU=section/CN=*"
else
  echo [INFO] Using existing ssl certificate
fi

if [ -s /app/smb.sh ] && $LOAD_SMB ; then
  echo [INFO] Mounting sambe shares
  chmod 755 /app/smb.sh
  bash /app/smb.sh
fi

service php7.0-fpm start
service nginx start

sleep 1

tail -f /app/logs/nginx/error.log
