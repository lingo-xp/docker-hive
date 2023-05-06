FROM lingoxp/hadoop-base:2.0.4-hadoop3.3.5-java8


HEALTHCHECK CMD curl -f http://localhost:9870/ || exit 1

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    krb5-kdc krb5-admin-server
ADD run.sh /run.sh
COPY ssl-client.xml /etc/hadoop/ssl-client.xml
COPY ssl-server.xml /etc/hadoop/ssl-server.xml
RUN chmod a+x /run.sh
#ADD run2.sh /run2.sh
#RUN chmod a+x /run2.sh

EXPOSE 9870

CMD ["/run.sh"]
