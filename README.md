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
sudo apt-get install ssh rsync openjdk-7-jdk
```

Standalone mode tests
===

```
cd hadoop-2.*/
mkdir input
cp etc/hadoop/*.xml input
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep input output 'dfs[a-z.]+'
cat output/*
```

Pseudo-distributed mode tests
===

```
cd hadoop-2.*/
mkdir input
cp etc/hadoop/*.xml input

hdfs namenode -format
start-dfs.sh
hdfs dfs -put input /
hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep /input /output 'dfs[a-z.]+'
hdfs dfs -cat output/*
stop-dfs.sh
```

Possible problems 
===

- Could not resolve hostname loaded: Name or service not known

Append `export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_PREFIX}/lib/native` to the last line of `etc/hadoop/hadoop-env.sh`

- could only be replicated to 0 nodes instead of minReplication (=1).  There are 0 datanode(s) running and no node(s) are excluded in this operation

```
stop-dfs.sh
rm -r /tmp/hadoop-USERNAME/dfs/name/*
rm -r /tmp/hadoop-USERNAME/dfs/data/*
hdfs namenode -format
start-dfs.sh
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

hive-installer
---

### Usage

```
./hive-installer.sh
source ~/.bashrc
```

### Tests

```
hive
hive> show databases;
hive> show tables;
```
pig-installer
---

### Usage

```
./pig-installer.sh
source ~/.bashrc
```

### Tests

```
pig
grunt> ls;
grunt> A = load '/etc/passwd' using PigStorage(':'); 
grunt> B = foreach A generate $0 as id; 
grunt> dump B; 
```

License
===

MIT
