#!/usr/bin/env bash

JAVA_HOME=""
HADOOP_DIR=""
HADOOP_TAR=hadoop-2.*.tar.gz
CORE_SITE_FILE=""
HDFS_SITE_FILE=""

function error()
{
    local msg="$1"
    echo -e "\033[1;31m[ERROR]\033[0m\t$msg"
    exit 1
}

function info()
{
    local msg="$1"
    echo -e "\033[1;32m[INFO]\033[0m\t$msg"
}

function check()
{
    if [ ! -f $HADOOP_TAR ]
    then
        error "Put $HADOOP_TAR in the same directory as this script
Available link: http://mirrors.hust.edu.cn/apache/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz"
    fi

    HADOOP_DIR=`file hadoop-2.* | grep "tar.gz" | awk -F ".tar.gz" '{print $1}'`
    CORE_SITE_FILE=$HADOOP_DIR/etc/hadoop/core-site.xml
    HDFS_SITE_FILE=$HADOOP_DIR/etc/hadoop/hdfs-site.xml

    dependencies=("java" "ssh" "rsync")
    for dep in "${dependencies[@]}"
    do
        if ! type "$dep" > /dev/null
        then
            error "Cannot find $dep"
        fi
    done

    read -p "Tell me the JAVA_HOME(/usr/lib/jvm/java-6-openjdk): " JAVA_HOME
    if [ ! "$JAVA_HOME" ]
    then
        JAVA_HOME=/usr/lib/jvm/java-6-openjdk
    fi

    if [ ! -d "$JAVA_HOME" ]
    then
        error "Invalid path"
    fi
    echo ""
}

function uncompress_hadoop_tar()
{
    tar xzf $HADOOP_TAR
}

function install_standalone()
{
    uncompress_hadoop_tar
    sed -i "s:^export JAVA_HOME=.*$:export JAVA_HOME=$JAVA_HOME:" $HADOOP_DIR/etc/hadoop/hadoop-env.sh

    core_site='<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
</configuration>'
    echo "$core_site" > $CORE_SITE_FILE

    hdfs_site='<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
</configuration>'
    echo "$hdfs_site" > $HDFS_SITE_FILE
}

function install_pseudo_distributed()
{
    uncompress_hadoop_tar
    sed -i "s:^export JAVA_HOME=.*$:export JAVA_HOME=$JAVA_HOME:" $HADOOP_DIR/etc/hadoop/hadoop-env.sh

    core_site='<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://localhost:9000</value>
    </property>
</configuration>'
    echo "$core_site" > $CORE_SITE_FILE

    hdfs_site='<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>dfs.replication</name>
        <value>1</value>
    </property>
</configuration>'
    echo "$hdfs_site" > $HDFS_SITE_FILE

    ssh-keygen -t dsa -P '' -f ~/.ssh/id_dsa
    ssh-add ~/.ssh/id_dsa
    cat ~/.ssh/id_dsa.pub > ~/.ssh/authorized_keys
}

# Main entrance
check

mode=$1
echo "+--------------------------+"
echo " 1 Standalone Mode"
echo " 2 Pseudo-distributed Mode"
echo "+--------------------------+"
read -p "Choose the mode you use(standalone mode): " choice

if [ ! "$choice" ]
then
    choice="1"
fi

if [ "$choice" == "1" ]
then
    install_standalone
    exit 0
elif [ "$choice" == "2" ]
then
    install_pseudo_distributed
    exit 0
else
    echo "Unrecognized argument"
    exit 1
fi
