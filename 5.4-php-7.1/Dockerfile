FROM shomatan/laravel-php-fpm:7.1.5-alpine

MAINTAINER Shoma Nishitateno <shoma416@gmail.com>

ENV LARAVEL_VERSION="5.4.*" LARAVEL_HOME=/var/www/html
ENV LARAVEL_APP_ENV="local" LARAVEL_APP_DEBUG="true"
ENV LARAVEL_DB_HOST="db" LARAVEL_DB_DATABASE="laravel" LARAVEL_DB_USERNAME="laravel" LARAVEL_DB_PASSWORD="laravel"

RUN set -xe \
    && composer create-project --prefer-dist "laravel/laravel=${LARAVEL_VERSION}" /home/www/app \
    && chown -R www:www /home/www/app

WORKDIR $LARAVEL_HOME

VOLUME $LARAVEL_HOME

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
