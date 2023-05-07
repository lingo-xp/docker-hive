#!/bin/bash

kinit -k -t /keys/historyserver.keytab root/historyserver@DIPEAK.COM
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver
