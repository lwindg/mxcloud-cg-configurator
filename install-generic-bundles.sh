#!/bin/sh

set -e

#pip install \
#	git+https://github.com/Sanji-IO/sanji.git#egg=sanji

BUNDLE_URL=http://192.168.31.74:8080/job/sanji-generic-debbuild/lastSuccessfulBuild/artifact

cd /tmp
wget $BUNDLE_URL/sanji-bundle-bootstrap-1.0.deb
wget $BUNDLE_URL/sanji-bundle-cellular-1.0.deb
wget $BUNDLE_URL/sanji-bundle-dhcpd-1.0.deb
wget $BUNDLE_URL/sanji-bundle-ethernet-1.0.deb
wget $BUNDLE_URL/sanji-bundle-firmware-1.0.deb
wget $BUNDLE_URL/sanji-bundle-ImportExport-1.0.0.deb
wget $BUNDLE_URL/sanji-bundle-network-monitor-1.0.deb	
wget $BUNDLE_URL/sanji-bundle-reboot-1.0.deb
wget $BUNDLE_URL/sanji-bundle-remote-1.0.0.deb
wget $BUNDLE_URL/sanji-bundle-route-1.0.deb
wget $BUNDLE_URL/sanji-bundle-schedule-1.0.0.deb
wget $BUNDLE_URL/sanji-bundle-ssh-1.0.deb
wget $BUNDLE_URL/sanji-bundle-status-1.0.deb
wget $BUNDLE_URL/sanji-bundle-time-1.0.deb

dpkg -i *.deb

cd /usr/lib/sanji-1.0
find . -maxdepth 2 -type f -name requirements.txt | xargs -I{} pip install -r {}

apt-get install vnstat isc-dhcp-server
