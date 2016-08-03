FROM php:7.0-apache

RUN apt-get update -qq \
    apt-get install -y unzip git-core \
    a2enmod rewrite

RUN pecl install xdebug \
    docker-php-ext-enable xdebug

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=1.2.0