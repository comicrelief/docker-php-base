FROM php:7.1-apache

# System packages
RUN apt-get update -qq  \
 && apt-get install -y unzip git-core libicu-dev vim-tiny \
 && rm -rf /var/lib/apt/lists/* /var/cache/apk/*

# Apache configuration
RUN a2enmod rewrite \
 && a2dissite 000-default \
 && echo ServerName localhost >> /etc/apache2/apache2.conf

COPY config/vhost/* /etc/apache2/sites-available/
COPY config/php.ini /usr/local/etc/php/

# PECL / extension builds and install
RUN pecl install xdebug \
 && docker-php-ext-enable xdebug \
 && docker-php-ext-install intl sockets opcache pdo_mysql

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Composer parallel install plugin
RUN composer global require hirak/prestissimo
