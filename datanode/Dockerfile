FROM lingoxp/hadoop-base:2.0.4-hadoop3.3.5-java8


HEALTHCHECK CMD curl -f http://localhost:9864/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data

ADD run.sh /run.sh
COPY commons-daemon-1.3.3-src.tar.gz /commons-daemon-1.3.3-src.tar.gz

RUN tar -xzvf commons-daemon-1.3.3-src.tar.gz && \
    cd commons-daemon-1.3.3-src/src/native/unix/ && \
    ./configure --with-java=/usr/bin/java && \
    make

RUN mkdir -p /hadoop/dfs/data && chmod a+x /run.sh
VOLUME /hadoop/dfs/data

EXPOSE 9864

CMD ["/run.sh"]
