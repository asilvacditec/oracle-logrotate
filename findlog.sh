#!/bin/bash

DIR="/home/oracle/hpdba/.cido"
FILECONFIG="${DIR}/logrotate.dba.dxc.conf"
LOGSTOSEARCH="alert*log listener*log"
DATE_ID=`date +%Y%m%d%H%M%S`

if [ -f ${FILECONFIG} ]; then
  mv ${FILECONFIG} ${FILECONFIG}.old.${DATE_ID}
fi

function findlog() {
  find /oracle/ -name "$1" 2>/dev/null | grep "\.log"$
}

for x in $LOGSTOSEARCH; do
  findlog $x >> $FILECONFIG
done

echo ""
echo ""
echo ""
echo "{" >> $FILECONFIG
echo "  weekly" >> $FILECONFIG
echo "  dateext" >> $FILECONFIG
echo "  create" >> $FILECONFIG
echo "  rotate 4" >> $FILECONFIG
echo "  copytruncate"  >> $FILECONFIG
echo "  missingok" >> $FILECONFIG
echo "  notifempyt" >> $FILECONFIG
echo "  compress" >> $FILECONFIG
echo "}" >> $FILECONFIG

echo "59 23 * * * /usr/sbin/logrotate -vf -s \
$DIR/logrotate.status $DIR/logrotate.dba.dxc.conf 1> \
$DIR/logrotate.log 2>&1" > $DIR/crontab_logrotate.txt

