#!/bin/bash

apt-get install -y build-essential autogen pkg-config texinfo libhogweed2 libgmp3-dev gettext
apt-get install -y build-essential libxml2-dev libgeos++-dev libpq-dev libbz2-dev libtool automake
apt-get install -y gnutls-bin
apt-get install -y unbound-anchor
mkdir /etc/unbound
unbound-anchor -a "/etc/unbound/root.key"

mkdir -p /opt/src

cd /opt/src
wget http://www.lysator.liu.se/~nisse/archive/nettle-2.7.tar.gz
tar xvzf nettle-2.7.tar.gz
cd /opt/src/nettle-2.7
./configure --enable-shared --prefix=/opt/local --disable-assembler
make
make install

cd /opt/src
wget http://artfiles.org/gnupg.org/gnutls/v3.2/gnutls-3.2.9.tar.xz
tar xvfJ gnutls-3.2.9.tar.xz
cd /opt/src/gnutls-3.2.9
PKG_CONFIG_PATH=/opt/local/lib/pkgconfig ./configure --enable-shared --prefix=/opt/local
make
make install

cd /opt/src
wget ftp://ftp.infradead.org/pub/ocserv/ocserv-0.10.1.tar.xz
tar xvf ocserv-0.10.1.tar.xz
cd /opt/src/ocserv-0.10.1
PKG_CONFIG_PATH=/opt/local/lib/pkgconfig ./configure --prefix=/opt/ocserv
LD_LIBRARY_PATH=/opt/local/lib make
make install
