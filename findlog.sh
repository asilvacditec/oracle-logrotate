#!/bin/bash
# Date: 19/12/2017
# Author: Aparecido Souza
# Desc: Install logrotate for oracle logfiles via crontab
#
#

DIR=`pwd`
FILECONFIG="${DIR}/logrotate.dba.dxc.conf"
DIRSTOSEARCH="/asm /oracle"
LOGSTOSEARCH="alert*log listener*log"
DATE_ID=`date +%Y%m%d%H%M%S`

if [ -f ${FILECONFIG} ]; then
  mv ${FILECONFIG} ${FILECONFIG}.old.${DATE_ID}
fi

function findlog() {
  find "${1}" -name "${2}" 2>/dev/null | grep "\.log"$
}

for x in ${DIRSTOSEARCH}; do
  for y in ${LOGSTOSEARCH}; do
        findlog "${x}" "${y}" >> "${FILECONFIG}"
  done
done


echo ""
echo ""
echo ""
echo "{" >> $FILECONFIG
echo "  weekly" >> $FILECONFIG
echo "  size 100M" >> $FILECONFIG
echo "  dateext" >> $FILECONFIG
echo "  create" >> $FILECONFIG
echo "  rotate 4" >> $FILECONFIG
echo "  copytruncate"  >> $FILECONFIG
echo "  missingok" >> $FILECONFIG
echo "  notifempty" >> $FILECONFIG
echo "  compress" >> $FILECONFIG
echo "}" >> $FILECONFIG

echo "" > $DIR/crontab_logrotate.txt
echo "" >> $DIR/crontab_logrotate.txt
echo "# DXCDBA - logrotate Oracle Database and Grid Infraestructure - ${DATE_ID}" >> $DIR/crontab_logrotate.txt
echo "59 23 * * * /usr/sbin/logrotate -vf -s \
${DIR}/logrotate.status ${DIR}/logrotate.dba.dxc.conf 1> \
${DIR}/logrotate.log 2>&1" >> ${DIR}/crontab_logrotate.txt

crontab -l > ${DIR}/backup_crontab.txt.${DATE_ID}

crontab -l > ${DIR}/crontab.tmp

cat ${DIR}/crontab_logrotate.txt >> ${DIR}/crontab.tmp

crontab crontab.tmp

crontab -l
