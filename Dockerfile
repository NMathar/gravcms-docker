FROM php:7.4-apache

# Based on the official Wordpress docker file

RUN a2enmod rewrite expires

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  libfreetype6-dev \
  libjpeg62-turbo-dev \
  libpng-dev \
  git \
  rsync \
  && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype --with-jpeg && docker-php-ext-install gd opcache zip mbstring


# install the PHP extensions we need
#RUN apt-get update && apt-get install -y git rsync libpng-dev libjpeg-dev zlib1g-dev && rm -rf /var/lib/apt/lists/* \
#	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
#	&& docker-php-ext-install gd opcache zip mbstring

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
		echo 'opcache.enable_cli=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini


RUN { \
                echo 'upload_max_filesize=25M'; \
		echo 'post_max_size=25M'; \
        } > /usr/local/etc/php/conf.d/custom-default.ini

ENV GRAV_VERSION 1.7.28
RUN curl -o grav.tar.gz -SL https://github.com/getgrav/grav/archive/${GRAV_VERSION}.tar.gz \
	&& mkdir -p /tmp/grav \
	&& tar -xzf grav.tar.gz -C /tmp \
	&& rsync -a /tmp/grav-${GRAV_VERSION}/ /var/www/html --exclude user \
	&& /var/www/html/bin/grav install \
	&& chown -R www-data:www-data /var/www/html \
	&& git config --global user.email "grav@getgrav.org" \
	&& git config --global user.name "grav"

COPY docker-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
CMD ["apache2-foreground"]
