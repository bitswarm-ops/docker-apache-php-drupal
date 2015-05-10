#!/bin/bash
set -e -x

if [ ! -e /opt/drupal ]; then
  echo "Installing Drupal core"
  git clone -b "${DRUPAL_CORE_VERSION}" https://github.com/drupal/drupal.git /opt/drupal
else
  cd /opt/drupal
  git pull origin "${DRUPAL_CORE_VERSION}"
  git checkout -B master "${DRUPAL_CORE_VERSION}"
fi

cd /opt/drupal
rsync -avqz --delete --stats --exclude=".git" --exclude="sites" . /app

# First time run will exclude sites (above), so we..
if [ ! -e /app/sites ]; then
  cd /opt/drupal/sites
  rsync -avz . /app/sites
fi

cd /app

if [ -e /app/composer.json ]; then
 if [ ! -e /app/composer.lock ]; then
    /usr/local/bin/composer install \
      --no-interaction \
      --no-progress \
      --ignore-platform-reqs
  else
    /usr/local/bin/composer update \
      --no-interaction \
      --no-progress \
      --ignore-platform-reqs
  fi
fi

if [ -e /etc/php5/fpm/pool.d/mysql.conf ]; then
  rm -f /etc/php5/fpm/pool.d/mysql.conf
fi

echo "env['MYSQL_DATABASE]='${MYSQL_DATABASE}'" > /etc/php5/fpm/pool.d/mysql.conf
echo "env['MYSQL_USER']='${MYSQL_USER}'" >> /etc/php5/fpm/pool.d/mysql.conf
echo "env['MYSQL_PASSWORD']='${MYSQL_PASSWORD}'" >> /etc/php5/fpm/pool.d/mysql.conf
echo "env['MYSQL_PREFIX']='${MYSQL_PREFIX}'" >> /etc/php5/fpm/pool.d/mysql.conf
echo "env['MYSQL_HOST']='${MYSQL_HOST}'" >> /etc/php5/fpm/pool.d/mysql.conf
echo "env['MYSQL_PORT']='${MYSQL_PORT}'" >> /etc/php5/fpm/pool.d/mysql.conf

echo "### Initialized php_fpm mysql.conf:"
cat /etc/php5/fpm/pool.d/mysql.conf

chown -R www-data:www-data /app /opt/drupal