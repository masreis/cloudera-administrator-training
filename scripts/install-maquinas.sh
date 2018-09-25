
#
apt-get install avro-tools crunch flume-ng hadoop-hdfs-fuse hadoop-httpfs hadoop-kms hive-hbase hive-webhcat hue-beeswax hue-hbase hue-impala hue-pig hue-plugins hue-rdbms hue-search hue-spark hue-sqoop hue-zookeeper impala impala-shell kite oozie pig pig-udf-datafu sentry solr-mapreduce spark-core spark-master spark-worker spark-python sqoop hue-security

# 

wget 'https://archive.cloudera.com/cm5/ubuntu/xenial/amd64/cm/cloudera.list' \
  -O /etc/apt/sources.list.d/cloudera-m.list

apt-get update

sudo apt-get install cloudera-manager-agent cloudera-manager-daemons

