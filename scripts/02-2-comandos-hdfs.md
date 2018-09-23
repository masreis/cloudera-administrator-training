## Os comandos são executados com o usuário hdfs
```
su - hdfs
hdfs
```

## Utilitário para checagem do sistema de arquivos
hdfs fsck <caminho> [parâmetro]

### Parâmetros

```
# hdfs fsck /user -list-corruptfileblocks #mostra a lista dos blocos corrompidos
hdfs fsck /user -delete # remove arquivos corrompidos
hdfs fsck /user -move # move os arquivos corrompidos para o diretório /lost+found
hdfs fsck /user -files # mostra os arquivos verificados
hdfs fsck /user -files -blocks # mostra os caminhos dos arquivos e seus blocos
hdfs fsck /user -files -blocks -locations # mostra a localização de cada bloco
hdfs fsck /user -files -blocks -racks # topologia dos blocos datanodes
```

### Mostra as informações de configuração
$ hdfs getconf <parametro>
Parâmetros
hdfs getconf -namenodes
hdfs getconf -secondaryNameNodes
hdfs getconf -nnRpcAddresses
hdfs getconf -confKey [propriedade] (continua...)

As configurações estão disponíveis em http://headnode.lab:8088/conf
Algumas delas:
dfs.datanode.address
dfs.namenode.name.dir
dfs.datanode.data.dir
dfs.replication
dfs.blocksize
dfs.heartbeat.interval
Exemplo:
$ hdfs getconf -confKey dfs.heartbeat.interval
$ hdfs getconf -confKey dfs.datanode.address

Utilitário de balanceamento do cluster
Com a adição de novos nós e a própria operação diária do cluster, podem acontecer desbalanceamentos
O objetivo é que os discos do cluster tenham aproximadamente a mesma utilização
Exemplo:
$ hdfs balancer: para balancear os datanodes
$ hdfs balancer -threshold 5: os datanodes podem ficar até 5% desbalanceados (padrão é 10%)

Informações básicas do sistema de arquivos
Para ver as opções:
$ hdfs dfsadmin

Topologia do cluster
$ hdfs dfsadmin -printTopology
Modo de segurança
$ hdfs dfsadmin -safemode enter|leave|get|wait
Quotas
$ hdfs dfsadmin -setQuota <limite> <diretório>: número limite para nomes de arquivos/diretórios
$ hdfs dfsadmin -clrQuota <diretório>: arquivos e diretórios ilimitados
$ hdfs dfsadmin -setSpaceQuota <espaço> <diretório>: total de espaço em disco usado pelos diretórios
$ hdfs dfsadmin -clrSpaceQuota <diretório>: espaço ilimitado


Para os comandos a seguir use o seu usuário no Linux
Crie um usuário no Linux igual ao criado no Hue:
$ useradd -m dataengineer -s /bin/bash
Para mudar a senha use o comando:
$ passwd dataengineer
Mude para o novo usuário use o comando:
$ su - dataengineer



O utilitário dfs apresenta comandos para manipulação de arquivos no HDFS
Utiliza sintaxe parecida com o Linux/Unix, com o objetivo de aproveitar o conhecimento da equipe de operação
Exemplo: cat, du, df, cp, mkdir e mv
Para listar as opções:
$ hdfs dfs


Copiar ou mover arquivos para o HDFS
Crie um arquivo local chamado arquivoDeExemplo.txt
A parâmetro opcional -f força a sobrescrita do arquivo
$ hdfs dfs -copyFromLocal arquivoDeExemplo.txt /user/dataengineer/
Verificar se foi copiado
$ hdfs dfs -ls /user/dataengineer/
Para mover o arquivo use o comando:
$ hdfs dfs -moveFromLocal arquivoDeExemplo.txt /user/dataengineer/
Comando alternativo (faz a mesma coisa)
$ hdfs dfs -put <-f> <arquivo-local> <diretorio-hdfs>

Cria um arquivo de tamanho 0
$ hdfs dfs -touchz /user/dataengineer/testeAppend.txt
Verifique o tamanho do arquivo
$ hdfs dfs -ls /user/dataengineer/
Anexa um ou vários arquivos locais em um arquivo do HDFS
$ hdfs dfs -appendToFile arquivoDeExemplo.txt /user/dataengineer/testeAppend.txt

cat
Mostra o conteúdo de um arquivo no terminal
$ hdfs dfs -cat testeAppend.txt
tail
Mostra os últimos 1000 bytes do arquivo
$ hdfs dfs -tail testeAppend.txt
text
Mostra o conteúdo de um arquivo, incluindo outros formatos não texto
$ hdfs dfs -text testeAppend.txt
Observação:
Para arquivos muito grandes deve-se usar o utilitário less
$ hdfs dfs -cat testeAppend.txt | less

Copia os dados de um diretório HDFS para o sistema de arquivos local
$ hdfs dfs -copyToLocal <arquivo-no-hdfs> <diretorio-local>
$ hdfs dfs -moveToLocal <arquivo-no-hdfs> <diretorio-local>
$ hdfs dfs -get <arquivo-no-hdfs> <diretorio-local>

Copia ou move os arquivos de um diretório HDFS para outro
$ hdfs dfs -cp <-f> <lista-de-arquivos-no-hdfs> <diretorio-destino-hdfs>
$ hdfs dfs -mv <-f> <lista-de-arquivos-no-hdfs> <diretorio-destino-hdfs>

count
Conta diretórios, arquivos e bytes
Formato do resultado: DIR_COUNT, FILE_COUNT, CONTENT_SIZE, PATHNAME
Parâmetros
-q: mostra também os dados de quota (QUOTA, REMAINING_QUATA, SPACE_QUOTA, REMAINING_SPACE_QUOTA)
-h (human): mostra os dados em formato mais legível
Exemplo:
$ hdfs dfs -count <-q -v -h> <diretorio>

df
Mostra o espaço livre em disco
Aceita a opção -h
Exemplo:
$ hdfs dfs -df -h
du
Mostra o espaço usado por arquivos e diretórios dentro de um diretório
A opção -s mostra o sumário
Exemplo:
$ hdfs dfs -du -s -h /user/dataengineer/

find
Encontra arquivos através de uma expressão de busca
Exemplo: 
$ hdfs dfs -find /user/ -name arquivoDeExemplo* -print
ls
Lista o conteúdo do diretório
Parâmetros
-d: diretórios listados como arquivos
-h: formata os números
-R: lista recursivamente os diretórios internos
Exemplo:
$ hdfs dfs -ls <diretorio>

stat
Mostra estatísticas acerca do arquivo
Opções: 
blocos (%b), tipo (%F), grupo (%g), nome (%n), tamanho do bloco (%o), replicação (%r), owner (%u) e data de modificação(%y, %Y).
Exemplo:
$ hdfs dfs -stat "%F %u:%g %b %y %n" <caminho-do-arquivo>
test
Testa um caminho com base nesses parâmetros:
-d: retorna 0 se o caminho é um diretório
-e: retorna 0 se o caminho existe
-f: retorna 0 se o caminho é um arquivo
-s: retorna 0 se o caminho não está vazio
-z: retorna 0 seo arquivo tem tamanho 0
Exemplo:
$ hdfs dfs -test -[defsz] <caminho>

rm
Exclui um arquivo ou diretório
Opções
-f: exclui e não mostra nenhum alerta
-R ou -r: exclui o diretório e seu conteúdo recursivamente (use com algum cuidado)
-skipTrash: exclui os dados imediatamente (evita a lixeira)
Exemplo:
$ hdfs dfs -rm [-f] [-r |-R] [-skipTrash] <caminho>
$ hdfs dfs -rm /user/dataengineer/arquivoDeTeste.txt
$ hdfs dfs -rm -r /user/dataengineer/diretorio
expunge
Inicia o processo para esvaziar a lixeira (pode demorar um pouco)
Exemplo
$ hdfs dfs -expunge


Muda o fator de replicação de um arquivo/diretório
A opção -w aguarda até que a operaçã termine
Não é indicada se existirem muitos arquivos no diretório
Exemplos:
$ hdfs dfs -setrep 2 /user/dataengineer/
$ hdfs dfs -setrep -w 2 /user/dataengineer/
$ hdfs dfs -du -h /user/dataengineer/


hdparm
Utilitário para configuração e medição de performance do discl
Instalação
$ sudo apt-get install hdparm
Exemplo:
$ sudo hdparm -I /dev/sda
$ sudo hdparm -Tt /dev/sda
Referência:
http://manpages.ubuntu.com/manpages/natty/man8/hdparm.8.html


Mede a velocidade de gravação e leitura
Velocidade de gravação (1GB de dados)
sudo dd if=/dev/zero of=/tmp/testfile bs=1G count=1
Latência do disco (1000 gravações de 384k)
sudo dd if=/dev/zero of=/tmp/testfile bs=384k count=1k
Referência:
https://www.thomas-krenn.com/en/wiki/Linux_I/O_Performance_Tests_using_dd

