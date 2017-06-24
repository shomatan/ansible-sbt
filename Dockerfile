FROM shomatan/laravel-php-fpm:7.1.5-alpine

MAINTAINER Shoma Nishitateno <shoma416@gmail.com>

ENV LARAVEL_VERSION="5.4.*" LARAVEL_HOME=/var/www/html

RUN set -xe \
    && composer create-project --prefer-dist "laravel/laravel=${LARAVEL_VERSION}" $LARAVEL_HOME \
    && chown -R www:www $LARAVEL_HOME

WORKDIR $LARAVEL_HOME

VOLUME $LARAVEL_HOME

COPY docker-entrypoint.sh /

ENTRYPOINT ["/bin/sh"]

CMD ["/docker-entrypoint.sh"]
