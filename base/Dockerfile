FROM ubuntu:20.04


RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      libsnappy-dev \
      krb5-user \
      tzdata  \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && rm -rf /var/lib/apt/lists/*


ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS

RUN gpg --import KEYS

ENV HADOOP_VERSION 3.3.5
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

COPY hadoop.tar.gz /tmp/hadoop.tar.gz

RUN tar -zxvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs

RUN mkdir /hadoop-data

ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV MULTIHOMED_NETWORK=1
ENV USER=root
ENV PATH $HADOOP_HOME/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh


RUN chmod a+x /entrypoint.sh
RUN echo "sun.security.krb5.disableReferrals=true" >> /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/lib/security/java.security && \
    echo "crypto.policy=unlimited" >> /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/lib/security/java.security

COPY local_policy.jar /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/lib/security/local_policy.jar
COPY US_export_policy.jar /usr/lib/jvm/java-1.8.0-openjdk-amd64/jre/lib/security/US_export_policy.jar
COPY krb5.conf /etc/krb5.conf

ENTRYPOINT ["/entrypoint.sh"]
