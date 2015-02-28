hadoop-installer
===

Hadoop 2.x installer on Ubuntu

Usage
===

```
git clone https://github.com/zhangxiaoyang/hadoop-installer
cd hadoop-installer
./hadoop-install.sh
```

Standalone Mode Test
===

```
cd hadoop-2.*/
mkdir input
cp etc/hadoop/*.xml input
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep input output 'dfs[a-z.]+'
cat output/*
```
Pseudo-Distributed Mode Test
===

```
cd hadoop-2.*/
bin/hdfs namenode -format
sbin/start-dfs.sh
bin/hdfs dfs -mkdir /input
bin/hdfs dfs -put etc/hadoop /input
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep input output 'dfs[a-z.]+'
bin/hdfs dfs -cat output/*
sbin/stop-dfs.sh
```

License
===

MIT
