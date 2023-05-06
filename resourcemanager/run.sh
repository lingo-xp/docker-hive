#!/bin/bash
kinit -k -t /server.keytab server/server-host@DIPEAK.COM
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager
