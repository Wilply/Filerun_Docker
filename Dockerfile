FROM debian:stretch
MAINTAINER Wilply

ARG DEBIAN_FRONTEND="noninteractive"

ENV DIR="/app"
ENV TZ="Europe/Paris"
ENV NGINX_USER="abc"

ENV PHP_PATH="/etc/php/7.0/fpm"

ENV LOCAL_DB="false"
ENV LOAD_SMB="false"

WORKDIR $DIR

RUN apt update && apt install -y \
    curl \
    gnupg2 \
    unzip \
    nginx \
    mariadb-server \
    ffmpeg \
    graphicsmagick \
    imagemagick \
    smbclient \
    ghostscript \
    php7.0 \
		php7.0-fpm \
		php7.0-common \
		php7.0-curl \
		php7.0-mbstring \
		php7.0-mcrypt \
		php7.0-mysql \
 		php7.0-exif \
		php7.0-xml \
		php7.0-zip \
		php7.0-gd \
    php7.0-opcache

#downloads
RUN curl -o /tmp/filerun.zip -L http://www.filerun.com/download-latest
RUN curl -o /tmp/ioncube.tar.gz -L https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

#create folder/user and set permission
RUN groupadd $NGINX_USER && useradd -M -N -g $NGINX_USER -d /var/www $NGINX_USER
RUN mkdir config data
RUN mkdir config/filerun config/logs config/self_keys
RUN mkdir config/logs/nginx config/logs/php
RUN unzip -q -u /tmp/filerun.zip -d $DIR/config/filerun/
RUN chown -R $NGINX_USER:$NGINX_USER ./ && chmod -R 750 ./

#install ioncube
RUN tar -xf /tmp/ioncube.tar.gz -C /tmp/
RUN mv /tmp/ioncube/ioncube_loader_lin_7.0.so `php -i | grep extension_dir | grep -o '\/.[^ ]*' | tail -1`
RUN echo zend_extension = \"$(php -i | grep extension_dir | grep -o '\/.[^ ]*' | tail -1)/ioncube_loader_lin_7.0.so\" > $PHP_PATH/conf.d/00-ioncube.ini
#"

#php
COPY files/filerun.ini $PHP_PATH/conf.d/
RUN echo date.timezone = "$TZ" >> $PHP_PATH/conf.d/filerun.ini
RUN echo error_log = "$DIR/config/logs/php/php_error.log" >> $PHP_PATH/conf.d/filerun.ini
RUN echo user=$NGINX_USER >> $PHP_PATH/php-fpm.conf && echo group=$NGINX_USER >> $PHP_PATH/php-fpm.conf
RUN echo listen.owner=$NGINX_USER >> $PHP_PATH/php-fpm.conf && echo listen.group=$NGINX_USER >> $PHP_PATH/php-fpm.conf

#nginx
RUN sed -i -e "s/user www-data/user $NGINX_USER/g" /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-available/default
COPY files/default /etc/nginx/sites-available/
RUN sed -i -e "s@CONFIG_PATH@$DIR@g" /etc/nginx/sites-available/default
RUN sed -i -e "s@/var/log/nginx/access.log@$DIR/config/logs/nginx/access.log@g" /etc/nginx/nginx.conf
RUN sed -i -e "s@/var/log/nginx/error.log@$DIR/config/logs/nginx/error.log@g" /etc/nginx/nginx.conf

#clear
RUN rm -rf /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

EXPOSE 80
EXPOSE 443

VOLUME /app/config
VOLUME /app/data

COPY files/start.sh /
COPY files/initdb.sql /
CMD ["/start.sh"]
