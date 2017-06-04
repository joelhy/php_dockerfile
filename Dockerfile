# Base image, official docker PHP image
FROM php:fpm

# change sources.list to faster mirror
ADD sources.list /etc/apt/sources.list

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
        && docker-php-ext-install -j$(nproc) gd iconv intl mbstring mcrypt mysqli pdo_mysql zip

# Install redis extension
# ADD https://github.com/phpredis/phpredis/archive/php7.tar.gz /tmp/redis.tar.gz
COPY redis.tar.gz /tmp/redis.tar.gz
RUN mkdir -p /usr/src/php/ext/redis \
  && tar xf /tmp/redis.tar.gz -C /usr/src/php/ext/redis --strip-components=1 \
  && docker-php-ext-configure redis \
  && docker-php-ext-install -j$(nproc) redis \
  && rm -rd /usr/src/php/ext/redis \
  && rm /tmp/redis.tar.gz

# Install memcached extension
# ADD https://github.com/php-memcached-dev/php-memcached/archive/php7.tar.gz /tmp/memcached.tar.gz
COPY memcached.tar.gz /tmp/memcached.tar.gz
RUN mkdir -p /usr/src/php/ext/memcached\
  && tar xf /tmp/memcached.tar.gz -C /usr/src/php/ext/memcached --strip-components=1 \
  && docker-php-ext-configure memcached \
  && docker-php-ext-install -j$(nproc) memcached \
  && rm -rd /usr/src/php/ext/memcached \
  && rm /tmp/memcached.tar.gz

VOLUME ["/usr/local/etc"]

EXPOSE 9000
