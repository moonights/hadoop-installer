hadoop-installer
===

Hadoop 2.x installer on Ubuntu

Usage
===

```
git clone https://github.com/zhangxiaoyang/hadoop-installer
cd hadoop-installer
./hadoop-install.sh
source ~/.bashrc
```

Dependencies
===

```
sudo apt-get install ssh rsync openjdk-6-jdk
```

Standalone mode test
===

```
cd hadoop-2.*/
mkdir input
cp etc/hadoop/*.xml input
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep input output 'dfs[a-z.]+'
cat output/*
```

Pseudo-distributed mode test
===

```
cd hadoop-2.*/
mkdir input
cp etc/hadoop/*.xml input

bin/hdfs namenode -format
sbin/start-dfs.sh
bin/hdfs dfs -put input /
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep /input /output 'dfs[a-z.]+'
bin/hdfs dfs -cat output/*
sbin/stop-dfs.sh
```

Possible problems 
===

- Could not resolve hostname loaded: Name or service not known

Append `export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native` to the last line of `etc/hadoop/hadoop-env.sh`

- could only be replicated to 0 nodes instead of minReplication (=1).  There are 0 datanode(s) running and no node(s) are excluded in this operation

```
sbin/stop-dfs.sh
rm -r /tmp/hadoop-USERNAME/dfs/name/*
rm -r /tmp/hadoop-USERNAME/dfs/data/*
bin/hdfs namenode -format
sbin/start-dfs.sh
```

Extended scripts
===

hadoop-eclipse-plugin-installer
---

### Usage

```
./hadoop-eclipse-plugin-installer.sh
```

### Dependencies

```
sudo apt-get install ant
```

### How to use this plugin

<http://www.linuxidc.com/Linux/2015-01/112369.htm>(written in Chinese)

License
===

MIT
