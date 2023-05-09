#!/bin/bash

echo "172.16.0.2    namenode" >> /etc/hosts
echo "172.16.0.3    datanode" >> /etc/hosts
echo "172.16.0.4    hive-server" >> /etc/hosts
echo "172.16.0.5    hive-metastore" >> /etc/hosts
echo "172.16.0.6    hive-metastore-postgresql" >> /etc/hosts
echo "172.16.0.7    resourcemanager" >> /etc/hosts
echo "172.16.0.8    nodemanager" >> /etc/hosts

kinit -k -t /keys/historyserver.keytab root/historyserver@DIPEAK.COM
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver
