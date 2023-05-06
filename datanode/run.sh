#!/bin/bash

datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`
if [ ! -d $datadir ]; then
  echo "Datanode data directory not found: $datadir"
  exit 2
fi

while :; do sleep 10; done

#$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode
