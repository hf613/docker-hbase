FROM ubuntu:14.04

MAINTAINER hanfan <330492846@qq.com>

WORKDIR /root

# install openssh-server, openjdk and wget
RUN apt-get update && apt-get install -y openssh-server wget

# install jdk 1.8
COPY jdk-8u201-linux-x64.tar.gz /root/
COPY hadoop-2.7.2.tar.gz /root/
COPY zookeeper-3.4.14.tar.gz /root/
COPY hbase-2.1.4-bin.tar.gz /root/
RUN mkdir -p /usr/lib/java && \
    tar -xzvf jdk-8u201-linux-x64.tar.gz -C /usr/lib/java/ && \
    rm jdk-8u201-linux-x64.tar.gz && \
    update-alternatives --install "/usr/bin/java" "java" "/usr/lib/java/jdk1.8.0_201/bin/java" 1 && \
    update-alternatives --install "/usr/bin/javac" "javac" "/usr/lib/java/jdk1.8.0_201/bin/javac" 1 && \
    update-alternatives --install "/usr/bin/javaws" "javaws" "/usr/lib/java/jdk1.8.0_201/bin/javaws" 1


# install hadoop 2.7.2
RUN tar -xzvf hadoop-2.7.2.tar.gz && \
    mv hadoop-2.7.2 /usr/local/hadoop && \
    rm hadoop-2.7.2.tar.gz
	
# install zookeeper 3.4.14
RUN tar -xzvf zookeeper-3.4.14.tar.gz && \
    mv zookeeper-3.4.14 /usr/local/zookeeper && \
    rm zookeeper-3.4.14.tar.gz

# install hbase 2.1.4
RUN tar -xzvf hbase-2.1.4-bin.tar.gz && \
    mv hbase-2.1.4 /usr/local/hbase && \
    rm hbase-2.1.4-bin.tar.gz

# set environment variable
ENV JAVA_HOME=/usr/lib/java/jdk1.8.0_201
ENV HADOOP_HOME=/usr/local/hadoop 
ENV ZOOKEEPER_HOME=/usr/local/zookeeper 
ENV HBASE_HOME=/usr/local/hbase
ENV PATH=$PATH:/usr/local/hadoop/bin:/usr/local/hadoop/sbin 

# ssh without key
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    touch ~/.ssh/known_hosts

RUN mkdir -p ~/hdfs/namenode && \ 
    mkdir -p ~/hdfs/datanode && \
    mkdir -p ~/zookeeper/data && \
    mkdir $HADOOP_HOME/logs

COPY config/* /tmp/

RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves && \
    mv /tmp/zoo.cfg $ZOOKEEPER_HOME/conf/zoo.cfg && \
    mv /tmp/hbase-env.sh $HBASE_HOME/conf/hbase-env.sh && \
    mv /tmp/hbase-site.xml $HBASE_HOME/conf/hbase-site.xml && \
    mv /tmp/regionservers $HBASE_HOME/conf/regionservers && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/start-zkServer.sh ~/start-zkServer.sh && \
    mv /tmp/start-hbase.sh ~/start-hbase.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh

RUN chmod +x ~/start-hadoop.sh && \
    chmod +x ~/start-zkServer.sh && \
    chmod +x ~/start-hbase.sh && \
    chmod +x ~/run-wordcount.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh 

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

CMD [ "sh", "-c", "service ssh start; bash"]
