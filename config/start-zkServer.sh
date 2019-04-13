#!/bin/bash
# the default node number is 3
zoodataDir=/root/zookeeper/data
N=${1:-3}
sudo mkdir -p $zoodataDir
sudo echo 1 > $zoodataDir/myid
i=1
while [ $i -lt $N ]
do
		sudo ssh root@hadoop-slave$i "echo $(( $i + 1 )) > $zoodataDir/myid"
		sudo ssh root@hadoop-slave$i "/usr/local/zookeeper/bin/zkServer.sh start"
        i=$(( $i + 1 ))
done 
sleep 10
/usr/local/zookeeper/bin/zkServer.sh start