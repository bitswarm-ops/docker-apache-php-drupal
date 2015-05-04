#!/bin/bash
set -e
source /build/buildconfig
set -x

## Temporarily disable dpkg fsync to make building faster.
echo force-unsafe-io > /etc/dpkg/dpkg.cfg.d/02apt-speedup

## Prevent initramfs updates from trying to run grub and lilo.
## https://journal.paul.querna.org/articles/2013/10/15/docker-ubuntu-on-rackspace/
## http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=594189
export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

## Enable Ubuntu Universe and Multiverse.
sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list

apt-get update

if [ ! -e /opt ]; then
  mkdir /opt
fi

if [ -e /build/keys/id_rsa ]; then
  cp /build/keys/id_rsa ${SERVICE_ACCT_HOME}/.ssh/id_rsa
  chmod 600 ${SERVICE_ACCT_HOME}/.ssh/id_rsa
  cp /build/keys/id_rsa /root/.ssh/id_rsa
  chmod 600 /root/.ssh/id_rsa
fi

if [ -e /build/keys/id_rsa.pub ]; then
  cp /build/keys/id_rsa.pub ${SERVICE_ACCT_HOME}/.ssh/id_rsa.pub
  cp /build/keys/id_rsa.pub ${SERVICE_ACCT_HOME}/.ssh/authorized_keys
  chmod 644 ${SERVICE_ACCT_HOME}/.ssh/id_rsa.pub
  chmod 644 ${SERVICE_ACCT_HOME}/.ssh/authorized_keys
  cp /build/keys/id_rsa.pub /root/.ssh/id_rsa.pub
  chmod 644 /root/.ssh/id_rsa.pub
fi

chown -R $SERVICE_ACCT:$SERVICE_ACCT ${SERVICE_ACCT_HOME}/.ssh
