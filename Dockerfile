FROM php:7.0-apache

# System packages
RUN apt-get update -qq  \
 && apt-get install -y unzip git-core libicu-dev nano
 && rm -rf /var/lib/apt/lists/* /var/cache/apk/*

# Apache configuration
RUN a2enmod rewrite \
 && a2dissite 000-default

COPY config/vhost/* /etc/apache2/sites-available/
COPY config/php.ini /usr/local/etc/php/

# PECL / extension builds and install
RUN pecl install xdebug \
 && docker-php-ext-enable xdebug \
 && docker-php-ext-install intl \
 && docker-php-ext-install sockets \
 && docker-php-ext-install opcache \
 && docker-php-ext-install pdo_mysql \
 && touch /tmp/mysql.sock

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.2.0
# Composer parallel install plugin
RUN composer global require hirak/prestissimo