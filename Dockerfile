FROM php:7-apache
WORKDIR /var/www/

RUN apt-get update && \
    apt-get install -y unzip libjpeg62-turbo-dev libpng12-dev libfreetype6-dev zlib1g-dev git && \
    apt-get clean && \
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-install -j$(nproc) gd && \
    docker-php-ext-install zip && \
    a2enmod rewrite

RUN cd /tmp && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    rm -rf /tmp/./*


RUN rm -rf html && \
    git clone https://github.com/getgrav/grav.git html && \
    cd html && \
    composer -n --no-ansi install && \
    bin/grav install && \ 
    chown -R www-data .


ENV PATH="/var/www/html/bin:$HOME/.composer/vendor/bin:${PATH}"

VOLUME /var/www/html

WORKDIR /var/www/html
