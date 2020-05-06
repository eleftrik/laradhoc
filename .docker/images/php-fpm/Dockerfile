ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

# Set working directory
WORKDIR /var/www

ARG ENABLE_XDEBUG
RUN if [ ${ENABLE_XDEBUG} = 1 ] ; then \
    pecl install xdebug \
    && echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.default_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.idekey='PHPSTORM'" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_output_dir='/opt/profile'" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && docker-php-ext-enable xdebug ;\
fi;

# Required for fixing an error while installing pdftk 
RUN mkdir /usr/share/man/man1/

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl \
    libmemcached-dev \
    libz-dev \
    libjpeg-dev \
    libpng-dev \
    libssl-dev \
    libmcrypt-dev \
    less \
    nano \
    vim \
    cron \
    git \
    unzip \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    pdftk

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN docker-php-ext-install pdo_mysql \
    pcntl \
    zip
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis
RUN if [[ ${PHP_VERSION} == 7.4* ]] ; then \
    docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j "$(nproc)" gd; \
fi;
RUN if [[ ${PHP_VERSION} == 7.2* ]] || [[ ${PHP_VERSION} == 7.3* ]] ; then \
    docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install gd;\
fi;
RUN docker-php-ext-install opcache

# Configure php.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN sed -e 's/max_execution_time = 30/max_execution_time = 600/' -i "$PHP_INI_DIR/php.ini"
RUN sed -e 's/memory_limit = 128M/memory_limit = 512M/' -i "$PHP_INI_DIR/php.ini"

# Cron
COPY ./cron /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron
RUN crontab /etc/cron.d/cron

# Configure opcache.ini
COPY ./conf.d/opcache.ini /tmp
RUN mv /tmp/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

# Add www user and www group
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Copy existing application directory permissions
RUN chown -R www: /var/www

# Change current user to www
USER www
