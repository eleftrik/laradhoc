ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

# Set working directory
WORKDIR /var/www

# Required for fixing an error while installing pdftk
RUN mkdir -p /usr/share/man/man1/

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl \
    libmemcached-dev \
    libz-dev \
    libjpeg-dev \
    libpng-dev \
    libwebp-dev \
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
    openjdk-17-jre-headless \
    ca-certificates-java \
    pdftk \
    libldap2-dev

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install extensions
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli
RUN docker-php-ext-install pdo_mysql \
    pcntl \
    zip
RUN pecl install -o -f redis \
    && rm -rf /tmp/pear \
    && docker-php-ext-enable redis
RUN case ${PHP_VERSION} in \
    8.3*|8.2*|8.1*|8.0*|7.4*) \
        docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
        && docker-php-ext-install gd; \
        ;; \
    *) \
        docker-php-ext-configure gd --with-gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
        --with-webp-dir=/usr/include/ \
        && docker-php-ext-install gd \
        ;; \
    esac;
RUN docker-php-ext-install opcache \
    && pecl install mongodb && docker-php-ext-enable mongodb

# Install the intl extension
RUN apt-get update && apt-get install -y \
    libicu-dev \
    && docker-php-ext-install intl \
    && docker-php-ext-enable intl

# Configure php.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
RUN sed -e 's/max_execution_time = 30/max_execution_time = 600/' -i "$PHP_INI_DIR/php.ini"
RUN sed -e 's/memory_limit = 128M/memory_limit = 512M/' -i "$PHP_INI_DIR/php.ini"

ARG ENABLE_XDEBUG
RUN if [ ${ENABLE_XDEBUG} = 1 ] ; then \
    case ${PHP_VERSION} in \
        8.3*) \
            pecl install xdebug-3.3.0alpha3; \
            echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.mode=profile" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.idekey='PHPSTORM'" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.output_dir='/opt/profile'" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && docker-php-ext-enable xdebug ;\
            ;; \
        8.2*|8.1*|8.0*|7.4*) \
            pecl install xdebug; \
            echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.mode=profile" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.start_with_request=trigger" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.discover_client_host=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.idekey='PHPSTORM'" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && echo "xdebug.output_dir='/opt/profile'" >> /usr/local/etc/php/conf.d/xdebug.ini \
            && docker-php-ext-enable xdebug ;\
            ;; \
        *) \
            pecl install xdebug; \
            echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
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
            ;; \
    esac; \
fi;

# Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

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