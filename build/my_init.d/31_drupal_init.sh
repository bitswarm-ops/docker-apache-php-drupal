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
rsync -avz --delete --exclude=".git" --exclude="sites" . /app

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