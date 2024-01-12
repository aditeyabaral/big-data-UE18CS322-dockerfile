FROM ubuntu:22.04

ARG HADOOP_VERSION=3.3.6
ARG HADOOP_MAJOR_VERSION=3
ARG SPARK_VERSION=3.5.0
EXPOSE 22 9870 9864 8088 8080
# Update and install Java

RUN apt update -y
RUN apt remove openssh-server openssh-client -y
RUN apt install ssh openssh-server openssh-client openjdk-8-jdk  -y 

USER root
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa  \
    && cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
    && chmod 0600 ~/.ssh/authorized_keys
RUN /etc/init.d/ssh start

# Install Hadoop

RUN wget https://downloads.apache.org/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz -O /root/hadoop-$HADOOP_VERSION.tar.gz
RUN tar -xzf /root/hadoop-$HADOOP_VERSION.tar.gz -C /root/
RUN rm /root/hadoop-$HADOOP_VERSION.tar.gz


RUN mkdir /root/tmpdata
RUN mkdir /root/dfsdata  \
    && mkdir /root/dfsdata/namenode  \
    && mkdir /root/dfsdata/datanode

RUN chown -R root:root /root/dfsdata/ \
    && chown -R root:root /root/dfsdata/namenode \
    && chown -R root:root /root/dfsdata/datanode

ENV HADOOP_HOME=/root/hadoop-$HADOOP_VERSION
ENV HADOOP_INSTALL=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_OPTS=-Djava.library.path=$HADOOP_HOME/lib/native
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="root"
ENV HDFS_SECONDARYNAMENODE_USER="root"
ENV YARN_RESOURCEMANAGER_USER="root"
ENV YARN_NODEMANAGER_USER="root"

COPY hadoop_conf/* /root/hadoop-$HADOOP_VERSION/etc/hadoop/
RUN $HADOOP_HOME/bin/hdfs namenode -format

# Install Spark

RUN apt install scala git -y

RUN wget https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_MAJOR_VERSION.tgz -O /root/spark-$SPARK_VERSION-bin-hadoop$HADOOP_MAJOR_VERSION.tgz
RUN tar -xzf /root/spark-$SPARK_VERSION-bin-hadoop$HADOOP_MAJOR_VERSION.tgz -C /root/
RUN rm /root/spark-$SPARK_VERSION-bin-hadoop$HADOOP_MAJOR_VERSION.tgz

ENV SPARK_HOME=/root/spark-$SPARK_VERSION-bin-hadoop$HADOOP_MAJOR_VERSION
ENV PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
ENV PYSPARK_PYTHON=python3

RUN chmod 777 /root/spark-$SPARK_VERSION-bin-hadoop$HADOOP_MAJOR_VERSION/sbin/*.sh
RUN chmod 777 /root/spark-$SPARK_VERSION-bin-hadoop$HADOOP_MAJOR_VERSION/bin/pyspark
RUN chmod 777 /root/spark-$SPARK_VERSION-bin-hadoop$HADOOP_MAJOR_VERSION/bin/spark-shell