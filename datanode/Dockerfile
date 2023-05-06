FROM lingoxp/hadoop-base:2.0.4-hadoop3.3.5-java8


HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data

ADD run.sh /run.sh
COPY ssl-client.xml /etc/hadoop/ssl-client.xml
COPY ssl-server.xml /etc/hadoop/ssl-server.xml
#COPY commons-daemon-1.3.3-src.tar.gz /commons-daemon-1.3.3-src.tar.gz
#COPY commons-daemon-1.3.3.jar /commons-daemon-1.3.3.jar
#RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
#    build-essential \
#    openssh-client
#RUN tar -xzvf commons-daemon-1.3.3-src.tar.gz && \
#    cd commons-daemon-1.3.3-src/src/native/unix/ && \
#    ./configure --with-java=/usr/lib/jvm/java-8-openjdk-amd64 && \
#    make && \
#    cp jsvc /opt/hadoop-3.3.5/libexec/ && \
#    rm /opt/hadoop-3.3.5/share/hadoop/hdfs/lib/commons-daemon-1.0.13.jar && \
#    mv /commons-daemon-1.3.3.jar /opt/hadoop-3.3.5/share/hadoop/hdfs/lib/


RUN mkdir -p /hadoop/dfs/data && chmod a+x /run.sh
VOLUME /hadoop/dfs/data

EXPOSE 9864

CMD ["/run.sh"]
