FROM lingoxp/hadoop-base:2.0.4-hadoop3.3.5-java8


#HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    krb5-kdc krb5-admin-server
ADD run.sh /run.sh
RUN chmod a+x /run.sh
ADD krb-env.sh /krb-env.sh
RUN chmod a+x /krb-env.sh
EXPOSE 9870
CMD ["/krb-env.sh"]
CMD [""]
CMD ["/run.sh"]
