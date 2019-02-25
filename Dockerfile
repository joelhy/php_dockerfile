# Base image, official docker PHP alpine image
FROM php:fpm-alpine

# # change to faster mirror
# RUN  echo > /etc/apk/repositories \
# && sed -i '1i\http://mirrors.ustc.edu.cn/alpine/v3.6/main/' /etc/apk/repositories \
# && sed -i '1i\http://mirrors.ustc.edu.cn/alpine/v3.6/community/' /etc/apk/repositories \
# && sed -i '1i\http://mirrors.aliyun.com/alpine/v3.6/main/' /etc/apk/repositories \
# && sed -i '1i\http://mirrors.aliyun.com/alpine/v3.6/community/' /etc/apk/repositories

RUN apk update --no-cache \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS icu-dev libxml2-dev \
        libmcrypt-dev libmemcached-dev cyrus-sasl-dev zlib-dev openssl-dev libzip-dev libbsd \
    # install gd
    && ( \
        apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
        && docker-php-ext-configure gd \
            --with-gd \
            --with-freetype-dir=/usr/include/ \
            --with-png-dir=/usr/include/ \
            --with-jpeg-dir=/usr/include/ \
        && NPROC=$(getconf _NPROCESSORS_ONLN) \
        && docker-php-ext-install -j${NPROC} gd \
        && apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev \
    ) \
  # install core extensions
  && docker-php-ext-install exif iconv intl mysqli opcache pdo_mysql soap zip \
  # install pecl extensions
  && pecl install mcrypt-1.0.2 && docker-php-ext-enable mcrypt \
  && pecl install redis && docker-php-ext-enable redis \
  && pecl update-channels \
  && echo no | pecl install memcached && docker-php-ext-enable memcached \
  && pecl install mongodb && docker-php-ext-enable mongodb \
  && pecl install xdebug-beta && docker-php-ext-enable xdebug \
  # clean up
  && apk del --no-cache .build-deps \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apk/* \
       /usr/share/doc/* /name/usr/share/man/* /usr/share/info/*
