#!/bin/bash

hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse

namedir='/keys'
while [  "`ls -A $namedir`" == "" ]; do
    sleep 10;
done

if [ -z "$HIVE_TYPE" ];then
	if [ "$HIVE_TYPE" == "server" ];then
	  echo "hive server start"
  	cd $HIVE_HOME/bin
    kinit -k -t /keys/hive-server.keytab root/hive-server@DIPEAK.COM
    ./hiveserver2 --hiveconf hive.server2.enable.doAs=false
  else
    echo "hive metastore start"
    kinit -k -t /keys/hive-metastore.keytab root/hive-metastore@DIPEAK.COM
  	/opt/hive/bin/hive --service metastore
  fi
else
	exit 1
fi


