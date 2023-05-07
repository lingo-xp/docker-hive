#!/bin/bash

kinit -k -t /keys/nodemanager.keytab root/nodemanager@DIPEAK.COM
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR nodemanager
