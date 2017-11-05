#!/bin/bash

unset SPARK_MASTER_PORT

if [ $SPARK_TYPE != "master" ] && [ $SPARK_TYPE != "worker" ]; then
  echo "SPARK_TYPE env var must be \"master\" or \"worker\""
  echo "Please set SPARK_TYPE accordingly."
  exit 2
fi

if [ $SPARK_TYPE = "master"  ]; then

  echo "Starting Spark Master Node..."
  echo "$(hostname -i) spark-master" >> /etc/hosts
  $SPARK_HOME/sbin/start-master.sh --ip spark-master --port 7077

fi


if [ $SPARK_TYPE = "worker"  ]; then

  echo "Starting Spark Worker Node..."
  $SPARK_HOME/sbin/start-slave.sh spark://spark-master:7077

fi