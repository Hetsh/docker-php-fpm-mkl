FROM hetsh/php-fpm:7.4.9-1
RUN apk add --no-cache \
    php7-json=7.4.9-r0 \
    php7-openssl=7.4.9-r0
