#!/bin/sh
#
# -----------------------------------------------------------------------------
set +e

# Default Laravel environment
LARAVEL_APP_ENV=${LARAVEL_APP_ENV:-"local"}
# Default Laravel debug mode
LARAVEL_APP_DEBUG=${LARAVEL_APP_DEBUG:-"true"}
# Default Database host
LARAVEL_DB_HOST=${LARAVEL_DB_HOST:-"db"}
# Default Database name
LARAVEL_DB_DATABASE=${LARAVEL_DB_DATABASE:-"laravel"}
# Default Database user name
LARAVEL_DB_USERNAME=${LARAVEL_DB_USERNAME:-"laravel"}
# Default Database user password
LARAVEL_DB_PASSWORD=${LARAVEL_DB_PASSWORD:-"laravel"}

echo "** Preparing Laravel app"

cp -r /home/www/app/* .

cat > .env <<EOF
APP_ENV=${LARAVEL_APP_ENV}
APP_DEBUG=${LARAVEL_APP_DEBUG}
APP_KEY=
 
DB_HOST=${LARAVEL_DB_HOST}
DB_DATABASE=${LARAVEL_DB_DATABASE}
DB_USERNAME=${LARAVEL_DB_USERNAME}
DB_PASSWORD=${LARAVEL_DB_PASSWORD}
 
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync
 
MAIL_DRIVER=smtp
MAIL_HOST=mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
EOF

php artisan key:generate
 
echo "** Waiting for MySQL"
until php artisan migrate --force; do
  >&2 echo "**** MySQL is unavailable - sleeping"
  sleep 1
done
 
echo "** Database seeding"
php artisan db:seed --force
 
chown -R www:www $LARAVEL_HOME

echo "########################################################"
 
echo "** Executing php-fpm"
 
exec php-fpm -F