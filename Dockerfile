# Base image, official docker PHP image
FROM php:5.6

# change sources.list to faster mirror
#ADD sources.list /etc/apt/sources.list

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  g++ \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libmemcached-dev \
  libpng12-dev \
  zlib1g-dev

# zlib1g-dev libicu-dev g++ for intl dependencies

# Install basic extensions
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
        && docker-php-ext-install -j$(nproc) gd iconv intl mbstring mcrypt mysql mysqli pdo_mysql zip

# Install redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install memcached extension
RUN pecl install memcached-2.2.0 \
    && docker-php-ext-enable memcached

# Install xdebug extension
RUN pecl install xdebug

#VOLUME ["/usr/local/etc"]
