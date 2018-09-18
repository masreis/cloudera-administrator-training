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
