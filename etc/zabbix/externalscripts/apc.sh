#!/bin/sh

TIMEOUT=10
TMPFILE=/tmp/apc.php

trap 'my_exit 1' 1 2 3 15

my_exit() {
  rm -f $TMPFILE
  echo $1
  exit $1
}

timeout $TIMEOUT curl -so $TMPFILE http://bio.jp.oracle.com/apc.php

FULL=`grep 'Cache full count' $TMPFILE | head -1 | sed 's!..*count</td><td>\(..*\)</td>..*!\1!'`
PHIT=`grep 'Hits:' $TMPFILE | head -1 | sed 's!..*(\(..*\)%)..*!\1!'`
PFREE=`grep 'Free:' $TMPFILE | head -1 | sed 's!..*(\(..*\)%)..*!\1!'`
TOTAL=`grep 'apc.shm_size' $TMPFILE | head -1 | sed 's!..*size</td><td>\([0-9][0-9]*\)M*</td>..*!\1!'`

zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k php.apc.full -o $FULL > /dev/null
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k php.apc.phit -o $PHIT > /dev/null
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k php.apc.pfree -o $PFREE > /dev/null
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -k php.apc.total -o $TOTAL > /dev/null

my_exit 0
