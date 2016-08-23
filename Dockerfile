FROM php:7.0-apache

COPY config/vhost/* /etc/apache2/sites-available/
COPY config/php.ini /usr/local/etc/php/

# System packages
RUN apt-get update -qq  \
 && apt-get install -y unzip git-core libicu-dev vim-tiny \
 && rm -rf /var/lib/apt/lists/* /var/cache/apk/*
 # Apache configuration
 && a2enmod rewrite \
 && a2dissite 000-default
 # PECL / extension builds and install
 && pecl install xdebug \
 && docker-php-ext-enable xdebug \
 && docker-php-ext-install intl opcache pdo_mysql sockets \
 && touch /tmp/mysql.sock
 # Composer
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
 # Composer parallel install plugin
 && composer global require hirak/prestissimo
