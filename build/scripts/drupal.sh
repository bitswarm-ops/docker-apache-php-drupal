#!/bin/bash
set -e
source /build/buildconfig
set -x

$minimal_apt_get_install mysql-client

cp -f /build/my_init.d/31_drupal_init.sh /etc/my_init.d/

/etc/my_init.d/30_composer_init.sh && /etc/my_init.d/31_drupal_init.sh
