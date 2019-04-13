1.拉码头图像
sudo docker pull kiwenlau/hadoop:1.0
2.克隆github存储库
git clone https://github.com/kiwenlau/hadoop-cluster-docker
3.创建hadoop网络
sudo docker network create --driver=bridge hadoop
4.启动容器
cd hadoop-cluster-docker
sudo ./start-container.sh
输出：

start hadoop-master container...
start hadoop-slave1 container...
start hadoop-slave2 container...
root@hadoop-master:~# 
启动3个容器，包含1个主设备和2个从设备
你将进入hadoop-master容器的/ root目录
5.开始hadoop
./start-hadoop.sh
6.运行wordcount
./run-wordcount.sh
产量

input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
任意大小的Hadoop集群
1.拉码头图像并克隆github存储库
像A部分一样做1~3

2.重建码头图像
sudo ./resize-cluster.sh 5
指定参数> 1：2,3 ..
这个脚本只是用不同的从属文件重建hadoop映像，它将所有从属节点的名称赋予特征
3.启动容器
sudo ./start-container.sh 5
使用与步骤2相同的参数
4.运行hadoop集群
像A节那样做5~6个
