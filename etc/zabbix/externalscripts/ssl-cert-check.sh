#! /bin/sh

SERVER=$1
PORT=$2
TIMEOUT=10

/etc/zabbix/externalscripts/timeout $TIMEOUT \
  /etc/zabbix/externalscripts/ssl-cert-check -s $SERVER -p $PORT -n |
  sed 's/  */ /g' |
  cut -f6 -d" "
