#!/usr/bin/env bash

HADOOP_VERSION=""
HADOOP_HOME=""
ECLIPSE_HOME=""

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
    dependencies=("ant")
    for dep in "${dependencies[@]}"
    do
        if ! type "$dep" > /dev/null
        then
            error "Cannot find $dep"
        fi
    done

    read -p "Tell me the HADOOP_VERSION(2.6.0): " HADOOP_VERSION
    if [ ! "$HADOOP_VERSION" ]
    then
        HADOOP_VERSION="2.6.0"
    fi

    read -p "Tell me the HADOOP_HOME(/usr/local/hadoop): " HADOOP_HOME
    if [ ! "$HADOOP_HOME" ]
    then
        HADOOP_HOME="/usr/local/hadoop"
    elif [ ! -d "$HADOOP_HOME" ]
    then
        error "Invalid path"
    fi

    read -p "Tell me the ECLIPSE_HOME(/usr/local/eclipse): " ECLIPSE_HOME
    if [ ! "$ECLIPSE_HOME" ]
    then
        ECLIPSE_HOME="/usr/local/eclipse"
    elif [ ! -d "$ECLIPSE_HOME" ]
    then
        error "Invalid path"
    fi
}

function install_plugin()
{
    git clone https://github.com/winghc/hadoop2x-eclipse-plugin
    cd hadoop2x-eclipse-plugin/src/contrib/eclipse-plugin
    ant jar -Dversion="$HADOOP_VERSION" -Declipse.home="$ECLIPSE_HOME" -Dhadoop.home="$HADOOP_HOME"
    cd -
    cp hadoop2x-eclipse-plugin/build/contrib/eclipse-plugin/hadoop-eclipse-plugin-"$HADOOP_VERSION".jar "$ECLIPSE_HOME/plugins"
}

# Main entrance
check
install_plugin
