#!/usr/bin/env bash

BASE_DIR=`pwd`
HIVE_DIR=""
HIVE_TAR=apache-hive-*.tar.gz

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
    if [ ! -f $HIVE_TAR ]
    then
        error "Put $HIVE_TAR in the same directory as this script
Available link: http://www.webhostingreviewjam.com/mirror/apache/hive/stable/apache-hive-1.0.0-bin.tar.gz"
    fi
    HIVE_DIR=`file apache-hive-* | grep "tar.gz" | awk -F ".tar.gz" '{print $1}'`
}

function register_hive()
{
    if [ "`grep '^export HIVE_HOME=' ~/.bashrc  | wc -l`" == "0" ]
    then
        echo "export HIVE_HOME=$BASE_DIR/$HIVE_DIR" >> ~/.bashrc
    else
        sed -i "s:^export HIVE_HOME=.*$:export HIVE_HOME=$BASE_DIR/$HIVE_DIR:" ~/.bashrc
    fi

    if [ "`grep '$HIVE_HOME/bin' ~/.bashrc  | wc -l`" == "0" ]
    then
        echo 'export PATH=$HIVE_HOME/bin:$PATH' >> ~/.bashrc
    fi
}

function uncompress_hive_tar()
{
    tar xzf $HIVE_TAR
}

function install_hive
{
    uncompress_hive_tar
    register_hive
}

# Main entrance
check
install_hive
