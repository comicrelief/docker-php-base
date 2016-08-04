FROM php:7.0-apache

# System packages
RUN apt-get update -qq  \
 && apt-get install -y unzip git-core libicu-dev

# Apache configuration
RUN a2enmod rewrite \
 && sed -i 's!/var/www/html!/var/www/html/public!g' /etc/apache2/sites-available/000-default.conf \
 && printf '[Date]\ndate.timezone=Europe/London' > /usr/local/etc/php/conf.d/timezone.ini \
 && a2dissite 000-default

COPY config/vhost/* /etc/apache2/sites-available/

# PECL / extension builds and install
RUN pecl install xdebug \
 && docker-php-ext-enable xdebug \
 && docker-php-ext-install intl \
 && docker-php-ext-install pdo_mysql \
 && touch /tmp/mysql.sock

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.2.0