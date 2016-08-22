FROM php:7.0-apache

COPY config/vhost/* /etc/apache2/sites-available/

RUN apt-get update -qq \
 # System packages
 && apt-get install -y unzip git-core libicu-dev \
 # Cleanup
 && du –sh /var/cache/apt/archives \
 && rm -rf /var/lib/apt/lists/* /var/cache/apk/* \
 # Apache configuration
 && a2enmod rewrite \
 && echo '[Date]\ndate.timezone=UTC' > /usr/local/etc/php/conf.d/timezone.ini \
 && a2dissite 000-default \
 # PECL / extension builds and install
 && pecl install xdebug \
 && docker-php-ext-enable xdebug \
 && docker-php-ext-install intl sockets opcache pdo_mysql \
 && touch /tmp/mysql.sock \
 # Configure PHP.ini
 && sed -i \
 -e "s/^expose_php.*/expose_php = Off/" \
 -e "s/^;date.timezone.*/date.timezone = UTC/" \
 -e "s/^memory_limit.*/memory_limit = -1/" \
 -e "s/^max_execution_time.*/max_execution_time = 300/" \
 -e "s/^post_max_size.*/post_max_size = 512M/" \
 -e "s/^upload_max_filesize.*/upload_max_filesize = 512M/" \
 -e "s/^error_reporting.*/error_reporting = E_ALL/" \
 -e "s/^display_errors.*/display_errors = On/" \
 -e "s/^display_startup_errors.*/display_startup_errors = On/" \
 -e "s/^track_errors.*/track_errors = On/" \
 -e "s/^mysqlnd.collect_memory_statistics.*/mysqlnd.collect_memory_statistics = On/" \
 /etc/php7/php.ini \
 && echo "error_log = \"/proc/self/fd/2\"" | tee -a /etc/php7/php.ini \
 # Configure OPCache
 && { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
 } > /usr/local/etc/php/conf.d/opcache-recommended.ini \
 # Composer
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 # Composer parallel install plugin
 && composer global require hirak/prestissimo 
