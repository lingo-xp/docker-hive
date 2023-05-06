#!/bin/bash
kinit -k -t /server.keytab server/server-host@DIPEAK.COM
$HADOOP_HOME/bin/hadoop jar $JAR_FILEPATH $CLASS_TO_RUN $PARAMS
