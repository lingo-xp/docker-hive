kadmin.local -q "addprinc -randkey hdfs/namenode@DIPEAK.COM "
kadmin.local -q "xst  -k namenode.keytab  hdfs/namenode@DIPEAK.COM  "