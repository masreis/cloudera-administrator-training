## Script para instalação:
```
sudo su - 
wget 'https://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/cloudera.list' \
  -O /etc/apt/sources.list.d/cloudera.list
apt-get update
apt-get install hadoop-client hive impala-shell
```


## Copiar arquivos de configuração
```
scp mapred-site.xml root@hadoopclient:/etc/hadoop/conf/
scp hive-site.xml root@hadoopclient:/etc/hive/conf
scp Downloads/hive/hive-conf/hive-site.xml root@hadoopclient:/etc/hive/conf
```

## Testar o acesso ao cluster
```
sudo -u hdfs hdfs dfs -ls /
sudo -u hdfs hdfs dfsadmin -printTopology
sudo -u yarn yarn node -list
```

## Cliente Beeline
```
beeline -n dataengineer -p dataengineer -u jdbc:hive2://edgenode.lab:10000
```

## Mostrar databases (Beeline)
```
> show databases;
```

## Cliente Impala
```
impala-shell -i datanode01.lab
```

## Mostrar databases (Impala Shell)
```
> show databases;
```

## API do Cloudera Manager

### Listar os clusters disponíveis
http://headnode.lab:7180/api/v18/clusters/

### Listar os dados do Cluster 1
http://headnode.lab:7180/api/v18/clusters/Cluster%201 

### Listar os serviços do Cluster 1
http://headnode.lab:7180/api/v19/clusters/Cluster%201/services

### Para listar as funcionalidades do HDFS (Selecione a propriedade name)
http://headnode.lab:7180/api/v19/clusters/Cluster%201/services/hdfs/roles


### Visualizar as configurações do namenode
http://headnode.lab:7180/api/v19/clusters/Cluster%201/services/hdfs/roles/hdfs-NAMENODE-ab8735db1bc6548069202e72e8a31842/process/

### URL Para baixar um dos arquivos, por exemplo o core-site.xml:
http://headnode.lab:7180/api/v19/clusters/Cluster%201/services/hdfs/roles/hdfs-NAMENODE-ab8735db1bc6548069202e72e8a31842/process/configFiles/core-site.xml

### Máquina Gateway
```
ssh root@edgenode
sudo -u hdfs hdfs dfs -ls /
sudo -u hdfs hdfs dfsadmin -printTopology
```
