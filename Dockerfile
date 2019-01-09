FROM centos:7.4.1708

MAINTAINER houalex <houalex@gmail.com>

WORKDIR /root

# install openssh-server, openjdk and wget
ENV DEBIAN_FRONTEND=noninteractive
RUN yum -y update
RUN yum install -y bash which openssh-server openssh-clients java-1.8.0-openjdk java-1.8.0-openjdk-devel wget

# config sshd
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config
# RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd
RUN mkdir /var/run/sshd
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN echo 'root:123456'|chpasswd
EXPOSE 22

# install hadoop 2.7.6
RUN wget https://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-2.7.6/hadoop-2.7.6.tar.gz && \
    tar -xzvf hadoop-2.7.6.tar.gz && \
    mv hadoop-2.7.6 /usr/local/hadoop && \
    rm hadoop-2.7.6.tar.gz

# install spark 2.2.2
RUN wget http://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-2.2.2/spark-2.2.2-bin-hadoop2.7.tgz && \
    tar -xzvf spark-2.2.2-bin-hadoop2.7.tgz && \
    mv spark-2.2.2-bin-hadoop2.7 /usr/local/spark && \
    rm spark-2.2.2-bin-hadoop2.7.tgz

# install parquet-tools-1.9.0
RUN wget http://maven.aliyun.com/nexus/content/groups/public/org/apache/parquet/parquet-tools/1.9.0/parquet-tools-1.9.0.jar && \
    mv parquet-tools-1.9.0.jar /usr/local/spark/jars

# set environment variable
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HDFS_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HADOOP_LIBEXEC_DIR=$HADOOP_HOME/libexec
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME/sbin 

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

RUN mkdir -p /data/hdfs/namenode && \ 
    mkdir -p /data/hdfs/datanode && \
    mkdir $HADOOP_HOME/logs && \
	mkdir /tmp/hadoop && \
	mkdir /tmp/spark

COPY config/hadoop/* /tmp/hadoop/

RUN mv /tmp/hadoop/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/hadoop/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/hadoop/stop-hadoop.sh ~/stop-hadoop.sh && \
    mv /tmp/hadoop/run-wordcount.sh ~/run-wordcount.sh

RUN chown -R root:root $HADOOP_HOME && \
    chown -R root:root $SPARK_HOME && \
    chown root:root ~/*.sh && \
    chmod +x ~/start-hadoop.sh && \
    chmod +x ~/stop-hadoop.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh && \
    chmod +x $HADOOP_HOME/sbin/stop-all.sh

COPY config/spark/* /tmp/spark/

RUN mv /tmp/spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh && \
    mv /tmp/spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf && \
    mv /tmp/spark/start-spark.sh ~/start-spark.sh && \
    mv /tmp/spark/stop-spark.sh ~/stop-spark.sh

RUN chown root:root ~/*.sh && \
    chmod +x ~/start-spark.sh && \
    chmod +x ~/stop-spark.sh && \
    chmod +x $SPARK_HOME/sbin/start-all.sh && \
    chmod +x $SPARK_HOME/sbin/stop-all.sh 

# format namenode
RUN /usr/local/hadoop/bin/hadoop namenode -format

# CMD [ "sh", "-c", "service ssh start; bash"]
CMD /usr/sbin/sshd -D
