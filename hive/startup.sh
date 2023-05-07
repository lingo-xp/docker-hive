#!/bin/bash



echo "172.16.0.2    namenode" >> /etc/hosts
echo "172.16.0.4    hive-server" >> /etc/hosts
echo "172.16.0.5    hive-metastore" >> /etc/hosts
echo "172.16.0.6    hive-metastore-postgresql" >> /etc/hosts


echo "$HIVE_TYPE"


if [ ! -z "$HIVE_TYPE" ];then
	if [ "$HIVE_TYPE" == "server" ];then
	  echo "hive server start"
	  echo "172.16.0.2    namenode" >> /etc/hosts
    echo "172.16.0.3    datanode" >> /etc/hosts
    echo "172.16.0.5    hive-metastore" >> /etc/hosts
    echo "172.16.0.6    hive-metastore-postgresql" >> /etc/hosts
    echo "172.16.0.7    resourcemanager" >> /etc/hosts
    echo "172.16.0.8    nodemanager" >> /etc/hosts
    echo "172.16.0.9    historyserver" >> /etc/hosts
    kinit -k -t /keys/hive-server.keytab root/hive-server@DIPEAK.COM
    hadoop fs -mkdir       /tmp
    hadoop fs -mkdir -p    /user/hive/warehouse
    hadoop fs -chmod g+w   /tmp
    hadoop fs -chmod g+w   /user/hive/warehouse
    /opt/hive/bin/hiveserver2 --hiveconf hive.server2.enable.doAs=false
  else
    echo "hive metastore start"
    echo "172.16.0.2    namenode" >> /etc/hosts
    echo "172.16.0.3    datanode" >> /etc/hosts
    echo "172.16.0.4    hive-server" >> /etc/hosts
    echo "172.16.0.6    hive-metastore-postgresql" >> /etc/hosts
    echo "172.16.0.7    resourcemanager" >> /etc/hosts
    echo "172.16.0.8    nodemanager" >> /etc/hosts
    echo "172.16.0.9    historyserver" >> /etc/hosts
    kinit -k -t /keys/hive-metastore.keytab root/hive-metastore@DIPEAK.COM
  	/opt/hive/bin/hive --service metastore
  fi
else
	exit 1
fi


