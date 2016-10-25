#!/bin/bash
apt-get -y --force-yes install dpkg-dev debhelper openbsd-inetd
# install dependancies
apt-get -y build-dep pure-ftpd
# build from source
mkdir /tmp/pure-ftpd-mysql/ && \
    cd /tmp/pure-ftpd-mysql/ && \
    apt-get source pure-ftpd-mysql && \
    cd pure-ftpd-* && \
    sed -i '/^optflags=/ s/$/ --without-capabilities/g' ./debian/rules && \
    dpkg-buildpackage -b -uc
# install the new deb files
dpkg -i /tmp/pure-ftpd-mysql/pure-ftpd-common*.deb
dpkg -i /tmp/pure-ftpd-mysql/pure-ftpd-mysql*.deb
# Prevent pure-ftpd upgrading
apt-mark hold pure-ftpd-common pure-ftpd-mysql
# setup ftpgroup and ftpuser
groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc ftpuser