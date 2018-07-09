FROM debian:stretch
MAINTAINER Wilply

ARG DEBIAN_FRONTEND="noninteractive"

ENV UID="2000"
ENV GID="2000"

ENV TZ="Europe/Paris"

ARG PHP_PATH="/etc/php/7.0/fpm"

ENV LOCAL_DB="false"
ENV LOAD_SMB="false"

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
RUN curl -o /tmp/filerun.zip -L http://www.filerun.com/download-latest \
      -o /tmp/ioncube.tar.gz -L https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

#create folder/user and set permission
RUN groupadd -g $GID abc && useradd -u $UID -M -N -g abc -d /var/www abc
COPY root/ /
WORKDIR /app
RUN unzip -q -u /tmp/filerun.zip -d filerun/ && \
      chown -R abc:abc filerun/

#install ioncube
RUN tar -xf /tmp/ioncube.tar.gz -C /tmp/ && \
      cp /tmp/ioncube/ioncube_loader_lin_7.0.so `php -i | grep extension_dir | grep -o '\/.[^ ]*' | tail -1` && \
      echo zend_extension = \"$(php -i | grep extension_dir | grep -o '\/.[^ ]*' | tail -1)/ioncube_loader_lin_7.0.so\" > $PHP_PATH/conf.d/00-ioncube.ini
#"

#php
RUN echo date.timezone = "$TZ" >> $PHP_PATH/conf.d/filerun.ini && \
      echo user=abc >> $PHP_PATH/php-fpm.conf && echo group=abc >> $PHP_PATH/php-fpm.conf && \
      echo listen.owner=abc >> $PHP_PATH/php-fpm.conf && echo listen.group=abc >> $PHP_PATH/php-fpm.conf

#clear
RUN rm -rf /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

EXPOSE 80
EXPOSE 443

VOLUME /app
VOLUME /data

CMD ["/scripts/start.sh"]
