#   Mendefinisikan base image yang digunakan
FROM php:7.2-apache 

#   Mendefinisikan working direktori
WORKDIR /var/www/html

#   Mengcopy source code kedalam container
COPY /code /var/www/html

#   Mengupdate dan menginstall beberapa package
RUN apt-get update && \
    apt-get install -y \
    git \
    zip \
    nano \
    curl

#   Menginstall extensi php
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install pdo_mysql

#   Menginstall composer untuk laravel
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

#   Merubah owner
RUN chown -R www-data:www-data /var/www
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

#   Mengcopy konfigurasi server dari host ke container folder ./code/docker/apache ke ./etc/apache2/sites-available
COPY /code/docker/apache /etc/apache2/sites-available

#   Merubah owner
RUN chown -R www-data:www-data /var/www/html

#   Mengenable mod_rewrite di apache
RUN a2enmod rewrite


