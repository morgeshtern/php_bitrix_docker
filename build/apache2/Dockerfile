FROM php:7.4-apache

WORKDIR /var/www

#RUN echo "Europe/Moscow" > /etc/timezone \
#    && dpkg-reconfigure tzdata

ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN deps=" \
       libgd3 \
       libgd-dev \
       libwebp-dev \
       libpng-dev libxpm-dev \
       apt-utils \
       curl \
       git \
       libbz2-dev \
       libc-client-dev \
       libfreetype6-dev \
       libgeoip-dev \
       libicu-dev \
       libjpeg-dev \
       libjpeg62-turbo-dev \
       libkrb5-dev \
       libldap2-dev \
       libmagickwand-dev \
       libmcrypt-dev \
       libmemcached-dev \
       libpq-dev \
       libpspell-dev \
       librrd-dev \
       libsasl2-dev \
       libtidy-dev \
       libtool \
       libxml2-dev \
       libxslt-dev \
       libonig-dev \
       gcc \
       mailutils \
       msmtp \
       sendmail \
       mariadb-client \
       pkg-config \
       sudo \
       telnet \
       unzip \
       wget \
       zlib1g-dev \
       libzip-dev \
       openssh-client \
      libmemcached11 \
       libmemcachedutil2 \
       build-essential \
       libz-dev\
       libapache2-mpm-itk\
       freetype*\
    "; \
    apt-get update && apt-get install -y \
       $deps \
    --no-install-recommends \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
    #&& docker-php-ext-configure gd \
         #-with-webp-dir=/usr/bin \
         #-with-freetype-dir=/usr/bin \
         #-with-jpeg-dir=/usr/bin \
         #-with-png-dir=/usr/bin \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure imap \
         --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap \
    && docker-php-ext-configure ldap \
        --with-libdir=lib/x86_64-linux-gnu/ \
    && pecl install apcu \
    && pecl install rrd \
    && docker-php-ext-enable rrd \
#    && docker-php-ext-enable apcu \
    && docker-php-ext-enable apcu \
    && pecl install geoip-1.1.1 \
    && docker-php-ext-enable geoip \
    && pecl install mcrypt \
    && docker-php-ext-enable mcrypt \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
#    && pecl install memcache \
#    && docker-php-ext-enable memcache \
    && wget https://github.com/websupport-sk/pecl-memcache/archive/4.0.4.zip \
    && unzip 4.0.4.zip -d /tmp \
    && rm 4.0.4.zip \
    && mv /tmp/pecl-memcache-4.0.4 /usr/src/php/ext/memcache \
    && docker-php-ext-install memcache \
#    && pecl install mongodb \
#    && docker-php-ext-enable mongodb \
#    && pecl install redis \
#    && docker-php-ext-enable redis \
#    && pecl install rrd \
#    && docker-php-ext-enable rrd \
    && docker-php-ext-install shmop \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
     && docker-php-ext-install -j$(nproc)\
        bcmath \
        bz2 \
        calendar \
        dba \
        exif \
        gettext \
        intl \
        ldap \
        mysqli \
        #mbstring \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        pspell \
        soap \
        sockets \
        tidy \
        xsl \
        zip

RUN { \
        echo '<IfModule remoteip_module>'; \
        echo 'RemoteIPHeader X-Forwarded-For'; \
        echo 'RemoteIPInternalProxy 172.16.1.1'; \
        echo '</IfModule>'; \
    } > /etc/apache2/mods-available/remoteip.conf

#RUN for i in {10001..10100} do \
#        groupadd -g $i www$1


RUN sed -i 's/LogFormat \"%h/LogFormat \"%a/g' /etc/apache2/apache2.conf

RUN a2enmod remoteip
RUN a2enmod rewrite ssl headers
RUN a2enmod mpm_itk
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

COPY apache2-foreground.sh /usr/local/bin/
CMD apache2-foreground.sh