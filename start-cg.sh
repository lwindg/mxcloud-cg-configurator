#!/bin/sh

CG_ID=cg-$(ip a show eth0 | grep link/ether | awk '{ print $2 }' | sed s/://g)
BG_PSK=$(grep "mqtt-tls-psk" /etc/mxc/fwd/configuration | awk '{ print $3 }')

. /home/moxa/mxcg_sanji-env/bin/activate

find /home/moxa/mxcg_sanji-env/bin -name "mxcg_sanji_*" | \
	xargs -I{} bash -c "python {} 2>&1 | logger -t {} &"

cd /usr/lib/sanji-1.0/bootstrap
REMOTE_PORT=8883 REMOTE_ID=server BG_PSK=$BG_PSK \
	REMOTE_HOST=192.168.31.81 LOCAL_ID=$CG_ID BG_ID=$CG_ID \
	BUNDLE_ENV=release \
	BUNDLES_HOME=/usr/lib/sanji-1.0 python bootstrap.py
