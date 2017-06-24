set +e

LARAVEL_APP_ENV=${LARAVEL_APP_ENV:-"local"}
LARAVEL_APP_DEBUG=${LARAVEL_APP_DEBUG:-"true"}
LARAVEL_DB_HOST=${LARAVEL_DB_HOST:-"localhost"}
LARAVEL_DB_DATABASE=${LARAVEL_DB_DATABASE:-"laravel"}
LARAVEL_DB_USERNAME=${LARAVEL_DB_USERNAME:-"laravel"}
LARAVEL_DB_PASSWORD=${LARAVEL_DB_PASSWORD:-"laravel"}

echo "** Preparing Laravel app"

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
 
chmod 777 -R storage

echo "########################################################"
 
echo "** Executing php-fpm"
 
exec php-fpm -F