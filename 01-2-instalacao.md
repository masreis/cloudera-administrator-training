# Todos os nós
sudo sed -i -e 's/127.0.1.1/#127.0.1.1/g' /etc/hosts
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
sudo sh -c "echo 'net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.conf"
sudo sysctl -p
cat /proc/sys/net/ipv6/conf/all/disable_ipv6
sudo sed -i -e 's/PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo service ssh restart
# Chaves (headserver01 como root)
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ssh-copy-id -i ~/.ssh/id_rsa.pub edgenode.lab
ssh-copy-id -i ~/.ssh/id_rsa.pub datanode01.lab
ssh-copy-id -i ~/.ssh/id_rsa.pub datanode02.lab
ssh-copy-id -i ~/.ssh/id_rsa.pub datanode03.lab

# Repositório (todos os nós como root)
wget 'https://archive.cloudera.com/cm5/ubuntu/xenial/amd64/cm/cloudera.list' -O /etc/apt/sources.list.d/cloudera.list
wget http://archive.cloudera.com/cdh5/ubuntu/xenial/amd64/cdh/archive.key
apt-key add archive.key
apt-get update
apt-get -y install oracle-j2sdk1.7 libmysql-java ntp
echo 10 > /proc/sys/vm/swappiness
sysctl -w vm.swappiness=10

# No MariaDB
grant all privileges on *.* to 'root'@'%'
    identified by 'root'  
    with grant option;
flush privileges;
grant all on *.* to 'scm'@'%' identified by 'scm' with grant option;
grant all on *.* to 'amon'@'%' identified by 'amon' with grant option;
grant all on *.* to 'hive'@'%' identified by 'hive' with grant option;
grant all on *.* to 'hue'@'%' identified by 'hue' with grant option;
grant all on *.* to 'rman'@'%' identified by 'rman' with grant option;
grant all on *.* to 'oozie'@'%' identified by 'oozie' with grant option;
#
CREATE DATABASE scm DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE amon DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE hive DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE hue DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE rman DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
CREATE DATABASE oozie DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;

# 
drop database amon;
drop database hive;
drop database hue;
drop database rman;
drop database oozie;
drop database scm;

# Instalar no headnode:
apt-get install cloudera-manager-daemons cloudera-manager-server
# Preparar as tabelas do Cloudera Manager Server (SCM Server)
/usr/share/cmf/schema/scm_prepare_database.sh mysql \
  -h mariadbserver \
  --scm-host headnode01.lab \
  scm scm scm
# Iniciar o serviço (demora alguns minutos)
service cloudera-scm-server start
# Monitorar o log
tail -f /var/log/cloudera-scm-server/cloudera-scm-server.log
# Acesse a URL para concluir a instalação com o Wizard:
http://headnode.lab:7180/
