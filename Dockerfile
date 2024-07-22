# Use a imagem base do Ubuntu
FROM ubuntu:latest

# Instale o servidor SSH e MongoDB
RUN apt-get update && apt-get install -y openssh-server mongodb && mkdir /var/run/sshd

# Configure o SSH para permitir login root com senha
RUN echo 'root:minha_senha' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Exponha a porta 22 e a porta padrão do MongoDB (27017)
EXPOSE 22 27017

# Script de inicialização para o MongoDB com autenticação
RUN echo '#!/bin/bash\n\
mongod --fork --logpath /var/log/mongodb.log --dbpath /data/db\n\
sleep 5\n\
mongo admin --eval "db.createUser({user:\"admin\", pwd:\"senha_mongodb\", roles:[{role:\"root\", db:\"admin\"}]})"\n\
mongod --shutdown\n\
mongod --auth --bind_ip_all --dbpath /data/db\n\
' > /usr/local/bin/init_mongo.sh

# Permissões de execução para o script de inicialização
RUN chmod +x /usr/local/bin/init_mongo.sh

# Comando para iniciar o SSH e MongoDB
CMD service ssh start && /usr/local/bin/init_mongo.sh
