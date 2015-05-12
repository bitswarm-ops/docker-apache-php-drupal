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

chown -R www-data:www-data /app /opt/drupal

mkdir -p /etc/service/php5-fpm/env.d
echo "${MYSQL_HOST}" > /etc/service/php5-fpm/env.d/MYSQL_HOST
echo "${MYSQL_PORT}" > /etc/service/php5-fpm/env.d/MYSQL_PORT
echo "${MYSQL_DATABASE}" > /etc/service/php5-fpm/env.d/MYSQL_DATABASE
echo "${MYSQL_PREFIX}" > /etc/service/php5-fpm/env.d/MYSQL_PREFIX
echo "${MYSQL_USER}" > /etc/service/php5-fpm/env.d/MYSQL_USER
echo "${MYSQL_PASSWORD}" > /etc/service/php5-fpm/env.d/MYSQL_PASSWORD
