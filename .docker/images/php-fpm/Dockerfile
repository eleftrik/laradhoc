FROM php:7.3-fpm
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

#    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
#    && echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/xdebug.ini \
RUN apt-get update
RUN apt-get install -y --no-install-recommends curl
RUN apt-get install -y --no-install-recommends libmemcached-dev
RUN apt-get install -y --no-install-recommends libz-dev
RUN apt-get install -y --no-install-recommends libjpeg-dev
RUN apt-get install -y --no-install-recommends libpng-dev
RUN apt-get install -y --no-install-recommends libssl-dev
RUN apt-get install -y --no-install-recommends libmcrypt-dev
RUN apt-get install -y --no-install-recommends nano
RUN apt-get install -y --no-install-recommends cron
RUN apt-get install -y --no-install-recommends git
RUN apt-get install -y --no-install-recommends unzip
RUN apt-get install -y --no-install-recommends libzip-dev
RUN apt-get install -y --no-install-recommends libfreetype6-dev
RUN apt-get install -y --no-install-recommends libjpeg62-turbo-dev
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install pcntl
RUN docker-php-ext-install zip
RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

RUN docker-php-ext-configure gd -with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install gd
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN sed -e 's/max_execution_time = 30/max_execution_time = 600/' -i "$PHP_INI_DIR/php.ini"
RUN sed -e 's/memory_limit = 128M/memory_limit = 512M/' -i "$PHP_INI_DIR/php.ini"
COPY ./cron /etc/cron.d/cron
RUN chmod 0644 /etc/cron.d/cron
RUN crontab /etc/cron.d/cron
