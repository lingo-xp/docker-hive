#!/bin/bash

hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse

cd $HIVE_HOME/bin
while :; do sleep 10; done
#kinit -k -t /server.keytab server/server-host@DIPEAK.COM
#./hiveserver2 --hiveconf hive.server2.enable.doAs=false
