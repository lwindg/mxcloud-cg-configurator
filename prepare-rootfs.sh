#!/bin/sh
# Prepare mxcloud testing environment from firmware V1.4

if [ "$1" == "" ];
	echo "Usage: $0 [ip-segment#4]"
	exit 1
fi

cd /tmp

# setup the network
cp -a /etc/resolv.conf /etc/resolv.conf.bak
cp -a /etc/network/interfaces /etc/network/interfaces.bak
cp -a /etc/hosts /etc/hosts.bak
echo "nameserver 192.168.50.33" > /etc/resolv.conf
sed -i "s|192.168.3.|192.168.31.|g" /etc/network/interfaces
sed -i "s|192.168.31.127|192.168.31.$1|g" /etc/network/interfaces
sed -i '11 a \\tgateway 192.168.31.254' /etc/network/interfaces
/etc/init.d/networking restart
ip route add default via 192.168.31.254
ntpdate 192.168.50.33


CG_PACKAGES=" \
python-dev \
python-pip \
syslog-ng \
"

# update packages
sed -i "s|debian.moxa.com|220.135.161.42|g" /etc/apt/sources.list
apt-get update; apt-get -y upgrade

# install packages
apt-get -y install ${CG_PACKAGES}

# install mosquitto (latest version)
wget http://repo.mosquitto.org/debian/mosquitto-repo.gpg.key
apt-key add mosquitto-repo.gpg.key
wget http://repo.mosquitto.org/debian/mosquitto-wheezy.list
mv mosquitto-wheezy.list /etc/apt/sources.list.d/
apt-get update
apt-get install -y mosquitto libmosquitto1 mosquitto-clients

# install sanji controller
wget -O sanji-controller_1.0.0_armhf.deb http://192.168.31.31/dokuwiki/lib/exe/fetch.php?media=software:linux:product:mxcloud:uc8100:sanji-controller_1.0.0_armhf.deb
dpkg -i sanji-controller_1.0.0_armhf.deb

cd /tmp

# install project packages
wget http://192.168.31.74:8080/job/mxc/lastSuccessfulBuild/artifact/build-deb/mxc_0.2.7-1_all.deb
wget http://192.168.31.74:8080/job/mxcg/lastSuccessfulBuild/artifact/build-deb/mxcg_0.2.0-1_all.deb
wget http://192.168.31.74:8080/job/mxc-sanji/lastSuccessfulBuild/artifact/build-deb/mxc-sanji_0.1.0-1_all.deb
wget http://192.168.31.74:8080/job/mxcg-sanji/lastSuccessfulBuild/artifact/build-deb/mxcg-sanji_0.3.0-1_all.deb
dpkg -i mxc_0.2.7-1_all.deb mxcg_0.2.0-1_all.deb \
	mxc-sanji_0.1.0-1_all.deb mxcg-sanji_0.3.0-1_all.deb

# install python packages
cd /home/moxa
pip install git+https://github.com/Sanji-IO/sanji.git#egg=sanji

echo 192.168.31.81 mxc-cs >> /etc/hosts
sed -i "s|#mqtt-tls-psk|mqtt-tls-psk|g" /etc/mxc/fwd/configuration

./install-generic-bundles.sh
#./clean-system

sed -i "s|220.135.161.42|debian.moxa.com|g" /etc/apt/sources.list
mv /etc/resolv.conf.bak /etc/resolv.conf
mv /etc/network/interfaces.bak /etc/network/interfaces
mv /etc/hosts.bak /etc/hosts
