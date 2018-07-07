#!/bin/bash

echo FILERUN DOCKERIZED BY WILPLY

if [ ! -s /firststart ] && [ $LOCAL_DB ] ; then
  echo [INFO] INIT MYSQL
  touch /firststart
  service mysql start
  mysql < /initdb.sql
elif [[ $LOCAL_DB ]]; then
  service mysql start
fi

if [ ! -s $DIR/config/self_keys/cert.key ] || [ ! -s $DIR/config/self_keys/cert.crt ]; then
  echo [INFO] No ssl cert or key found, generate new
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $DIR/config/self_keys/cert.key -out $DIR/config/self_keys/cert.crt -subj "/C=EN/ST=Some-State/L=city/O=Internet Widgits Pty Ltd/OU=section/CN=*"
else
  echo [INFO] Using existing ssl certificate
fi

service php7.0-fpm start
service nginx start

sleep 1

tail -f $DIR/config/logs/nginx/error.log
