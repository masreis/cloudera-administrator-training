## Os comandos são executados com o usuário hdfs
```
su - hdfs
hdfs
```

## Utilitário para checagem do sistema de arquivos
hdfs fsck <caminho> [parâmetro]

### Parâmetros

```
hdfs fsck /user -list-corruptfileblocks # mostra a lista dos blocos corrompidos
hdfs fsck /user -delete # remove arquivos corrompidos
hdfs fsck /user -move # move os arquivos corrompidos para o diretório /lost+found
hdfs fsck /user -files # mostra os arquivos verificados
hdfs fsck /user -files -blocks # mostra os caminhos dos arquivos e seus blocos
hdfs fsck /user -files -blocks -locations # mostra a localização de cada bloco
hdfs fsck /user -files -blocks -racks # topologia dos blocos nos datanodes
```

### Mostra as informações de configuração
```
hdfs getconf <parametro>
# Parâmetros
hdfs getconf -namenodes
hdfs getconf -secondaryNameNodes
hdfs getconf -nnRpcAddresses
hdfs getconf -confKey [propriedade]
```

As configurações estão disponíveis em http://headnode.lab:8088/conf
Algumas delas:

1. dfs.datanode.address
1. dfs.namenode.name.dir
1. dfs.datanode.data.dir
1. dfs.replication
1. dfs.blocksize
1. dfs.heartbeat.interval

Exemplo:

```
hdfs getconf -confKey dfs.heartbeat.interval
hdfs getconf -confKey dfs.datanode.address
```

### Utilitário de balanceamento do cluster

```
hdfs balancer: para balancear os datanodes
hdfs balancer -threshold 5 # os datanodes podem ficar até 5% desbalanceados (padrão é 10%)
```

### Informações básicas do sistema de arquivos
```
hdfs dfsadmin
# Topologia do cluster
hdfs dfsadmin -printTopology
# Modo de segurança
hdfs dfsadmin -safemode enter|leave|get|wait
# Quotas
hdfs dfsadmin -setQuota <limite> <diretório>: número limite para nomes de arquivos/diretórios
hdfs dfsadmin -clrQuota <diretório>: arquivos e diretórios ilimitados
hdfs dfsadmin -setSpaceQuota <espaço> <diretório>: total de espaço em disco usado pelos diretórios
hdfs dfsadmin -clrSpaceQuota <diretório>: espaço ilimitado
```

### Adicionar usuário no Linux (root)
```
useradd -m dataengineer -s /bin/bash
passwd dataengineer
su - dataengineer
```

### Manipulação de arquivos no HDFS
```
hdfs dfs
# Copiar ou mover arquivos para o HDFS
hdfs dfs -copyFromLocal arquivoDeExemplo.txt /user/dataengineer/
hdfs dfs -ls /user/dataengineer/
hdfs dfs -moveFromLocal arquivoDeExemplo.txt /user/dataengineer/
hdfs dfs -put <-f> <arquivo-local> <diretorio-hdfs>

# Cria um arquivo de tamanho 0
hdfs dfs -touchz /user/dataengineer/testeAppend.txt
# Verifique o tamanho do arquivo
hdfs dfs -ls /user/dataengineer/
# Anexa um ou vários arquivos locais em um arquivo do HDFS
hdfs dfs -appendToFile arquivoDeExemplo.txt /user/dataengineer/testeAppend.txt
```

### Mostra o conteúdo de um arquivo no terminal
```
# cat
hdfs dfs -cat testeAppend.txt

# tail
hdfs dfs -tail testeAppend.txt

# text
hdfs dfs -text testeAppend.txt

# Para arquivos muito grandes deve-se usar o utilitário less
hdfs dfs -cat testeAppend.txt | less
```

### Cópia
```
hdfs dfs -copyToLocal <arquivo-no-hdfs> <diretorio-local>
hdfs dfs -moveToLocal <arquivo-no-hdfs> <diretorio-local>
hdfs dfs -get <arquivo-no-hdfs> <diretorio-local>

hdfs dfs -cp <-f> <lista-de-arquivos-no-hdfs> <diretorio-destino-hdfs>
hdfs dfs -mv <-f> <lista-de-arquivos-no-hdfs> <diretorio-destino-hdfs>
```

### count
Conta diretórios, arquivos e bytes. Formato do resultado: DIR_COUNT, FILE_COUNT, CONTENT_SIZE, PATHNAME
Parâmetros
1. -q: mostra também os dados de quota (QUOTA, REMAINING_QUATA, SPACE_QUOTA, REMAINING_SPACE_QUOTA)
1. -h (human): mostra os dados em formato mais legível

Exemplo:

```
hdfs dfs -count <-q -v -h> <diretorio>
```

### df
Mostra o espaço livre em disco. Aceita a opção -h. Exemplo:

```
hdfs dfs -df -h
```

### du
Mostra o espaço usado por arquivos e diretórios dentro de um diretório. A opção -s mostra o sumário. Exemplo:

```
hdfs dfs -du -s -h /user/dataengineer/
```

### find
Encontra arquivos através de uma expressão de busca. Exemplo: 

```
hdfs dfs -find /user/ -name arquivoDeExemplo* -print
```

### ls
Lista o conteúdo do diretório. Parâmetros:

1. -d: diretórios listados como arquivos
1. -h: formata os números
1. -R: lista recursivamente os diretórios internos

Exemplo:

```
hdfs dfs -ls <diretorio>
```

### stat
Mostra estatísticas acerca do arquivo. Opções: blocos (%b), tipo (%F), grupo (%g), nome (%n), tamanho do bloco (%o), replicação (%r), owner (%u) e data de modificação(%y, %Y).

Exemplo:

```
hdfs dfs -stat "%F %u:%g %b %y %n" <caminho-do-arquivo>
```

### test
Testa um caminho com base nesses parâmetros:

1. -d: retorna 0 se o caminho é um diretório
1. -e: retorna 0 se o caminho existe
1. -f: retorna 0 se o caminho é um arquivo
1. -s: retorna 0 se o caminho não está vazio
1. -z: retorna 0 seo arquivo tem tamanho 0

Exemplo:

```
hdfs dfs -test -[defsz] <caminho>
```

### rm
Exclui um arquivo ou diretório. Opções: 

1. -f: exclui e não mostra nenhum alerta
1. -R ou -r: exclui o diretório e seu conteúdo recursivamente (use com algum cuidado)
1. -skipTrash: exclui os dados imediatamente (evita a lixeira)

Exemplo:

```
hdfs dfs -rm [-f] [-r |-R] [-skipTrash] <caminho>
hdfs dfs -rm /user/dataengineer/arquivoDeTeste.txt
hdfs dfs -rm -r /user/dataengineer/diretorio
```

### expunge
Inicia o processo para esvaziar a lixeira (pode demorar um pouco). Exemplo:

```
hdfs dfs -expunge
```

### setrep
Muda o fator de replicação de um arquivo/diretório. A opção -w aguarda até que a operaçã termine. Não é indicada se existirem muitos arquivos no diretório. Exemplos:

```
hdfs dfs -setrep 2 /user/dataengineer/
hdfs dfs -setrep -w 2 /user/dataengineer/
hdfs dfs -du -h /user/dataengineer/
```

# Opcional
hdparm - utilitário para configuração e medição de performance do disco
Instalação
```
sudo apt-get install hdparm
sudo hdparm -I /dev/sda
sudo hdparm -Tt /dev/sda
```

dd - Mede a velocidade de gravação e leitura. Velocidade de gravação (1GB de dados)
```
sudo dd if=/dev/zero of=/tmp/testfile bs=1G count=1
# Latência do disco (1000 gravações de 384k)
sudo dd if=/dev/zero of=/tmp/testfile bs=384k count=1k
```

### Referência:
http://manpages.ubuntu.com/manpages/natty/man8/hdparm.8.html
https://www.thomas-krenn.com/en/wiki/Linux_I/O_Performance_Tests_using_dd

