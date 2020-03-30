#!/bin/sh
#backup zabbix config only
#Original link https://www.zabbix.com/forum/zabbix-help/22576-copying-duplicating-zabbix-configuration
#Changed by Hernandes Martins
#Date: 21/05/2018
#Atualizacao: 02/12/2019
#Testado em Zabbix 4.4

#Variaveis Mysql
DBNAME=zabbix
DBUSER=zabbix
DBPASS=zabbix

#Variaveis time_range
DATESTART=1498065946
DATEFINISH=1529601946

#Path Backup Direcory
BK_DEST=/opt/

#Zabbix schema
mysqldump -u$DBUSER  -p"$DBPASS" -B "$DBNAME" --no-data  --skip-lock-tables > "$BK_DEST/$DBNAME-1-schema.sql"

#Zabbix config
mysqldump -u"$DBUSER"  -p"$DBPASS" -B "$DBNAME" --single-transaction --skip-lock-tables --no-create-info --no-create-db \
    --ignore-table="$DBNAME.acknowledges" \
    --ignore-table="$DBNAME.alerts" \
    --ignore-table="$DBNAME.auditlog" \
    --ignore-table="$DBNAME.auditlog_details" \
    --ignore-table="$DBNAME.events" \
    --ignore-table="$DBNAME.history" \
    --ignore-table="$DBNAME.history_log" \
    --ignore-table="$DBNAME.history_str" \
    --ignore-table="$DBNAME.history_text" \
    --ignore-table="$DBNAME.history_uint" \
    --ignore-table="$DBNAME.trends" \
    --ignore-table="$DBNAME.trends_uint" \
    > "$BK_DEST/$DBNAME-2-config.sql"

#Dump Table Zabbix History by time
mysqldump -u$DBUSER  -p"$DBPASS" $DBNAME --single-transaction --no-create-info history --where="clock BETWEEN \"DATESTART\" and \"DATEFINISH\"" > "$BK_DEST/$DBNAME-3-history.sql"

#Dump Table Zabbix trends by time
mysqldump -u$DBUSER  -p"$DBPASS" $DBNAME --single-transaction --no-create-info trends --where="clock BETWEEN \"DATESTART\" and \"DATEFINISH\"" > "$BK_DEST/$DBNAME-4-trends.sql"

tar -zcf backup.tar zabbix-1-schema.sql zabbix-2-config.sql zabbix-3-history.sql zabbix-4-trends.sql

#sshpass -p "password" scp backup.tar root@192.168.0.113:/opt/
sshpass -p "password" scp backup.tar root@192.168.0.113:/opt/