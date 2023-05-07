#!/bin/bash

kinit -k -t /keys/resourcemanager.keytab root/resourcemanagert@DIPEAK.COM
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR resourcemanager
