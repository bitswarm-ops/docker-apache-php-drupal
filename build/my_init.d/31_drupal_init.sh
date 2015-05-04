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

rsync -av --delete --exclude=".git" --exclude="sites" /opt/drupal/ /app

if [ ! -e /app/composer.lock ]; then
  cd /app
  /usr/local/bin/composer install \
    --no-interaction \
    --no-progress \
    --ignore-platform-reqs
else
  cd /app
  /usr/local/bin/composer update \
    --no-interaction \
    --no-progress \
    --ignore-platform-reqs
fi

chown -R www-data:www-data /app /opt/drupal