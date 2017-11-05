# Complete SSD stack for Kubernetes!
## _Small Smart Data_ ! 

### _A Complete Dev and Prod Environment!_

---------------------------
# Contents:
* Apache Spark 2.2.0
* Hadoop HDFS 2.7.4
* Elasticsearch 6.0.0 rc2
* kibana 6.0.0 rc2
* Cassandra
* Zeppelin
* Spark Apps: ReducedIIbStream, ReducedAccessLogStream...

# Quick Start:

### A) Running via docker-compose

**1)** Be sure to have the Docker Compose installed. Head to "https://docs.docker.com/compose/install/" if not.

**2)** Create a virtual network in order to organize your docker infrastructure (_**optional**_)

```
$ docker network create \
  --driver=bridge \
  --subnet=192.168.24.0/22 \
  --gateway=192.168.24.1 \
  --label=apps \
  --label=defaultapps \
  default_apps
```
This will create the `default_apps` virtual network with `1022` private addrress, as you can see bellow (http://jodies.de/ipcalc?host=192.168.24.0&mask1=22&mask2=):
```
--------------------------------------------------------------------------
Address:   192.168.24.0          11000000.10101000.000110 00.00000000
Netmask:   255.255.252.0 = 22    11111111.11111111.111111 00.00000000
Wildcard:  0.0.3.255             00000000.00000000.000000 11.11111111
=>
Network:   192.168.24.0/22       11000000.10101000.000110 00.00000000 (Class C)
Broadcast: 192.168.27.255        11000000.10101000.000110 11.11111111
HostMin:   192.168.24.1          11000000.10101000.000110 00.00000001
HostMax:   192.168.27.254        11000000.10101000.000110 11.11111110
Hosts/Net: 1022                  (Private Internet)
--------------------------------------------------------------------------
```

**3)** Clone the github repo 

```
$ git clone https://github.com/rafabsb/docker-spark-hdfs.git
```

**4)** Start the project
```
$ cd docker-spark-hdfs
$ docker-compose up
```
**5)** To check that Spark and Hadoop HDFS are running, hit the links bellow:

* http://localhost:8080 --> Spark Standalone Cluster WebUI.
* http://localhost:50070 --> Hadoop HDFS Web UI

You shoud see 3 worker (spark) and 3 datanodes (hadoop hdfs) in the UIs.


