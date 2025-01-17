#!/bin/bash

datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`
if [ ! -d $datadir ]; then
  echo "Datanode data directory not found: $datadir"
  exit 2
fi

namedir='/keys'
while [  "`ls -A $namedir`" == "" ]; do
    sleep 10;
done


keytool -keystore keystore -alias localhost -validity 9999 -genkey -keyalg RSA -keysize 2048 -dname "cn=Unknown, ou=Unknown, o=Unknown, c=Unknown" -keypass 123456 -storepass 123456 -noprompt

keytool -keystore truststore -alias CARoot -import -file /keys/ca_cert -keypass 123456 -storepass 123456 -noprompt

keytool -keystore keystore -alias CARoot -import -file /keys/ca_cert -keypass 123456 -storepass 123456 -noprompt

keytool -certreq -alias localhost -keystore keystore -file local_cert -keypass 123456 -storepass 123456 -noprompt

openssl x509 -req -CA /keys/ca_cert -CAkey /keys/ca_private.key -in local_cert -out local_cert_signed -days 9999 -CAcreateserial

keytool -keystore keystore -alias localhost -import -file local_cert_signed -keypass 123456 -storepass 123456

echo "172.16.0.2    namenode" >> /etc/hosts
echo "172.16.0.4    hive-server" >> /etc/hosts
echo "172.16.0.5    hive-metastore" >> /etc/hosts
echo "172.16.0.6    hive-metastore-postgresql" >> /etc/hosts
echo "172.16.0.7    resourcemanager" >> /etc/hosts
echo "172.16.0.8    nodemanager" >> /etc/hosts
echo "172.16.0.9    historyserver" >> /etc/hosts

kinit -k -t /keys/datanode.keytab root/datanode@DIPEAK.COM
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode
