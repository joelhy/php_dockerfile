# Base image, official docker PHP image
FROM php:5.6-apache

# change sources.list to faster mirror
#ADD sources.list /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  apt-utils \
  g++ \
  libfreetype6-dev \
  libgmp-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libmemcached-dev \
  libpng-dev \
  zlib1g-dev \
  libxml2-dev \
  libssl-dev

# Fixing "configure: error: Unable to locate gmp.h"
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h 

# zlib1g-dev libicu-dev g++ for intl dependencies

# Install basic extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j$(nproc) gd gmp iconv intl mbstring mcrypt mysqli pdo_mysql zip soap exif \
          mysql

# Install redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install memcached extension
RUN pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

# Install xdebug extension
RUN pecl install xdebug-2.5.5

# Install mongodb extension
RUN pecl install mongodb \
    && docker-php-ext-install bcmath \
    && docker-php-ext-enable mongodb

RUN a2enmod rewrite

#VOLUME ["/usr/local/etc"]
#VOLUME ["/etc/apache2"]

EXPOSE 80
