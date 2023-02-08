#!/bin/bash

wget https://mirror.rackspace.com/mariadb//mariadb-10.10.3/bintar-linux-systemd-x86_64/mariadb-10.10.3-linux-systemd-x86_64.tar.gz

tar -xvzf mariadb-10.10.3-linux-systemd-x86_64.tar.gz

mkdir mariadb-10.10.3-linux-x86_64

mv mariadb-10.10.3-linux-systemd-x86_64/bin/mariadb mariadb-10.10.3-linux-x86_64/mariadb

zip mariadb-10.10.3-linux-x86_64.zip mariadb-10.10.3-linux-x86_64/mariadb

rm -Rf mariadb-10.10.3-linux-systemd-x86_64.tar.gz mariadb-10.10.3-linux-systemd-x86_64 mariadb-10.10.3-linux-x86_64

