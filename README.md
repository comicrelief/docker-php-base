# Docker  php7-base

This is php base docker image to be extended by other Dockerfile's for more specific use cases.
Currently supported php versions
- 7.2
- 7.1
- 7.0

Example usage of this base image:
- [docker-php-drupal](https://github.com/comicrelief/docker-php-drupal)
- [docker-php-slim](https://github.com/comicrelief/docker-php-slim)

## PHP extensions
 - apcu
 - bcmath
 - intl
 - opcache
 - pdo_mysql
 - sockets
 - xdebug

## Apache vhost config
This docker image provides apache vhost site configurations to be enabled in Dockerfile which extends this one.
- **public.conf**: Web directory is `public`
- **public-ssl.conf**: Web directory is `public` and has ssl enabled. 
Expects `local.key` and `local.crt` in `/var/www/html/config/ssl/` directory. 
- **web.conf**: Web directory is `web`
- **web-ssl.conf**: Web directory is `web` and has ssl enabled. 
Expects `local.key` and `local.crt` in `/var/www/html/config/ssl/` directory.
