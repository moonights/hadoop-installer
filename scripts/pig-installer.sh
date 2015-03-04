#!/usr/bin/env bash

BASE_DIR=`pwd`
PIG_DIR=""
PIG_TAR=pig-*.tar.gz

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
    if [ ! -f $PIG_TAR ]
    then
        error "Put $PIG_TAR in the same directory as this script
Available link: http://mirror.cc.columbia.edu/pub/software/apache/pig/latest/pig-0.14.0.tar.gz"
    fi
    PIG_DIR=`file pig-* | grep "tar.gz" | awk -F ".tar.gz" '{print $1}'`
}

function register_pig()
{
    if [ "`grep '^export PIG_HOME=' ~/.bashrc  | wc -l`" == "0" ]
    then
        echo "export PIG_HOME=$BASE_DIR/$PIG_DIR" >> ~/.bashrc
    else
        sed -i "s:^export PIG_HOME=.*$:export PIG_HOME=$BASE_DIR/$PIG_DIR:" ~/.bashrc
    fi

    if [ "`grep '$PIG_HOME/bin' ~/.bashrc  | wc -l`" == "0" ]
    then
        echo 'export PATH=$PIG_HOME/bin:$PATH' >> ~/.bashrc
    fi
}

function uncompress_pig_tar()
{
    tar xzf $PIG_TAR
}

function install_pig
{
    uncompress_pig_tar
    register_pig
}

# Main entrance
check
install_pig
