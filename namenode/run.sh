#!/bin/bash

if [ -z ${KRB5_REALM} ]; then
    echo "No KRB5_REALM provided. Exiting ..."
    exit 1
fi

if [ -z ${KRB5_KDC} ]; then
    echo "No KRB5_KDC provided. Exiting ..."
    exit 1
fi

if [ -z ${KRB5_ADMINSERVER} ]; then
    echo "No KRB5_ADMINSERVER provided; Using ${KRB5_KDC} instead."
    KRB5_ADMINSERVER=${KRB5_KDC}
fi

echo "Creating Krb5 Client Configuration"

cat <<EOT > /etc/krb5.conf
[libdefaults]
 dns_lookup_realm = false
 ticket_lifetime = 24h
 renew_lifetime = 7d
 forwardable = true
 rdns = false
 default_realm = ${KRB5_REALM}

 [realms]
 ${KRB5_REALM} = {
    kdc = ${KRB5_KDC}
    admin_server = ${KRB5_ADMINSERVER}
 }
EOT

if [ ! -f "/var/lib/krb5kdc/principal" ]; then

    echo "No Krb5 database found. Creating one now."

    if [ -z ${KRB5_PASS} ]; then
        echo "No Password for kdb provided; Creating one now."
        KRB5_PASS=`< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;`
        echo "Using Password ${KRB5_PASS}"
    fi

    echo "Creating KDC configuration"
cat <<EOT > /var/lib/krb5kdc/kdc.conf
[kdcdefaults]
    kdc_listen = 88
    kdc_tcp_listen = 88

[realms]
    ${KRB5_REALM} = {
        kadmin_port = 749
        max_life = 12h 0m 0s
        max_renewable_life = 7d 0h 0m 0s
        master_key_type = aes256-cts
        supported_enctypes = aes256-cts:normal aes128-cts:normal
        default_principal_flags = +preauth
    }

[logging]
    kdc = FILE:/var/log/krb5kdc.log
    admin_server = FILE:/var/log/kadmin.log
    default = FILE:/var/log/krb5lib.log
EOT

echo "Creating default policy - Admin access to */admin"
echo "*/admin@${KRB5_REALM} *" > /var/lib/krb5kdc/kadm5.acl
echo "*/service@${KRB5_REALM} aci" >> /var/lib/krb5kdc/kadm5.acl

    echo "Creating temporary password file"
cat <<EOT > /etc/krb5_pass
${KRB5_PASS}
${KRB5_PASS}
EOT

    echo "Creating krb5util database"
    kdb5_util create -r ${KRB5_REALM} < /etc/krb5_pass
    rm /etc/krb5_pass

    echo "Creating admin account"
    kadmin.local -q "addprinc -pw ${KRB5_PASS} admin/admin@${KRB5_REALM}"

fi
echo "Start kdc service"
krb5kdc
kadmin

echo "172.16.0.3    datanode" >> /etc/hosts
echo "172.16.0.4    hive-server" >> /etc/hosts
echo "172.16.0.5    hive-metastore" >> /etc/hosts
echo "172.16.0.6    hive-metastore-postgresql" >> /etc/hosts
echo "172.16.0.7    resourcemanager" >> /etc/hosts
echo "172.16.0.8    nodemanager" >> /etc/hosts
echo "172.16.0.9    historyserver" >> /etc/hosts


mkdir -p /keys
rm /keys/*
cd /keys
echo "generate namenode.keytab"

kadmin.local -q "addprinc -randkey root/namenode@DIPEAK.COM"
kadmin.local -q "xst  -k namenode.keytab  root/namenode@DIPEAK.COM"


kadmin.local -q "addprinc -randkey root/datanode@DIPEAK.COM"
kadmin.local -q "xst  -k datanode.keytab  root/datanode@DIPEAK.COM"

kadmin.local -q "addprinc -randkey root/hive-server@DIPEAK.COM"
kadmin.local -q "xst  -k hive-server.keytab  root/hive-server@DIPEAK.COM"

kadmin.local -q "addprinc -randkey root/hive-metastore@DIPEAK.COM"
kadmin.local -q "xst  -k hive-metastore.keytab  root/hive-metastore@DIPEAK.COM"

kadmin.local -q "addprinc -randkey root/resourcemanager@DIPEAK.COM"
kadmin.local -q "xst  -k resourcemanager.keytab  root/resourcemanager@DIPEAK.COM"

kadmin.local -q "addprinc -randkey root/nodemanager@DIPEAK.COM"
kadmin.local -q "xst  -k nodemanager.keytab  root/nodemanager@DIPEAK.COM"

kadmin.local -q "addprinc -randkey root/historyserver@DIPEAK.COM"
kadmin.local -q "xst  -k historyserver.keytab  root/historyserver@DIPEAK.COM"

openssl req -nodes -new -x509 -keyout ca_private.key -out ca_cert -days 9999 -subj '/C=CN/ST=hangzhou/O=bigdata/OU=bigdata/CN=master'

cd /

keytool -keystore keystore -alias localhost -validity 9999 -genkey -keyalg RSA -keysize 2048 -dname "cn=Unknown, ou=Unknown, o=Unknown, c=Unknown" -keypass 123456 -storepass 123456 -noprompt

keytool -keystore truststore -alias CARoot -import -file /keys/ca_cert -keypass 123456 -storepass 123456 -noprompt

keytool -keystore keystore -alias CARoot -import -file /keys/ca_cert -keypass 123456 -storepass 123456 -noprompt

keytool -certreq -alias localhost -keystore keystore -file local_cert -keypass 123456 -storepass 123456 -noprompt

openssl x509 -req -CA /keys/ca_cert -CAkey /keys/ca_private.key -in local_cert -out local_cert_signed -days 9999 -CAcreateserial

keytool -keystore keystore -alias localhost -import -file local_cert_signed -keypass 123456 -storepass 123456



cd /
kinit -k -t /keys/namenode.keytab hdfs/namenode@DIPEAK.COM
namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`
if [ ! -d $namedir ]; then
  echo "Namenode name directory not found: $namedir"
  exit 2
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified"
  exit 2
fi

echo "remove lost+found from $namedir"
rm -r $namedir/lost+found

if [ "`ls -A $namedir`" == "" ]; then
  echo "Formatting namenode name directory: $namedir"
  $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME
fi

kinit -k -t /keys/namenode.keytab root/namenode@DIPEAK.COM

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
