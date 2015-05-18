#!/bin/sh

set -e

#pip install \
#	git+https://github.com/Sanji-IO/sanji.git#egg=sanji

mkdir -p /usr/lib/sanji-1.0
cd /usr/lib/sanji-1.0

git clone https://github.com/Sanji-IO/sanji-bundle-remote.git remote
git clone https://github.com/Sanji-IO/sanji-bootstrap.git bootstrap
git clone https://github.com/Sanji-IO/sanji-import-export.git import-export
git clone https://github.com/Sanji-IO/sanji-bundle-routes.git route
git clone https://github.com/Sanji-IO/sanji-bundle-schedule.git schedule
git clone https://github.com/Sanji-IO/sanji-cellular.git cellular
git clone https://github.com/Sanji-IO/sanji-dhcp.git dhcp
git clone https://github.com/Sanji-IO/sanji-ethernet.git ethernet
git clone https://github.com/Sanji-IO/sanji-network-bandwidth.git network-bandwidth
git clone https://github.com/Sanji-IO/sanji-reboot.git reboot
git clone https://github.com/Sanji-IO/sanji-ssh.git ssh
git clone https://github.com/Sanji-IO/sanji-status.git status
git clone https://github.com/Sanji-IO/sanji-time.git time
git clone https://github.com/Sanji-IO/sanji-firmware.git firmware

#find . -maxdepth 2 -type d -name .git | xargs rm -rf
find . -maxdepth 2 -type f -name requirements.txt | xargs -I{} pip install -r {}

apt-get install vnstat isc-dhcp-server
