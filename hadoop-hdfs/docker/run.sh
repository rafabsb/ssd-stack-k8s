#!/bin/bash

function addProperty() {
  local path=$1
  local name=$2
  local value=$3

  local entry="<property><name>$name</name><value>${value}</value></property>"
  local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
  sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
}

function configure() {
    local path=$1
    local module=$2
    local envPrefix=$3

    local var
    local value
    
    echo "Configuring $module"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do 
        name=`echo ${c} | perl -pe 's/___/-/g; s/__/@/g; s/_/./g; s/@/_/g;'`
        var="${envPrefix}_${c}"
        value=${!var}
        echo " - Setting $name=$value"
        addProperty $HADOOP_CONF_DIR/$module-site.xml $name "$value"
    done
}

if [ $HADOOP_TYPE != "namenode" ] && [ $HADOOP_TYPE != "datanode" ]; then
	echo "HADOOP_TYPE env var must be \"namenode\" or \"datanode\""
	echo "Please set HADOOP_TYPE in the docker-compose.yml file accordingly"
	exit 2
fi

if [ -z "$CLUSTER_NAME" ]; then
  echo "Cluster name not specified."
  exit 2
fi

configure $HADOOP_CONF_DIR/core-site.xml core CORE_CONF
configure $HADOOP_CONF_DIR/hdfs-site.xml hdfs HDFS_CONF


#if [ -e $SPARK_HOME/conf/core-site.xml ]; then
#	ln -s $HADOOP_CONF_DIR/core-site.xml $SPARK_HOME/conf/core-site.xml
#fi
#
#if [ -e $SPARK_HOME/conf/hdfs-site.xml ]; then
#	ln -s $HADOOP_CONF_DIR/hdfs-site.xml $SPARK_HOME/conf/hdfs-site.xml
#fi

tmpdir=`echo $CORE_CONF_hadoop_tmp_dir`
if [ ! -d $tmpdir ]; then
  echo "Hadoop tmpdir directory not found: $tmpdir"
  echo "Creating $tmpdir"
  mkdir -p $tmpdir
fi

datadir=`echo $HDFS_CONF_dfs_datanode_data_dir | perl -pe 's#file://##'`
if [ ! -d $datadir ]; then
  echo "Datanode data directory not found: $datadir"
  echo "Creating $datadir"
  mkdir -p $datadir
fi

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`
if [ ! -d $namedir ]; then
  echo "Namenode name directory not found: $namedir"
  echo "Creating $namedir"
  mkdir -p $namedir
fi


if [ $HADOOP_TYPE = "namenode"  ] && [ "`ls -A $namedir`" == "" ]; then
  echo "$(hostname -i) hadoop-namenode" >> /etc/hosts
 	echo "Formatting namenode name directory: $namedir"
  	$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format $CLUSTER_NAME 

fi

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR $HADOOP_TYPE