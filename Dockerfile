# Use a imagem base do Ubuntu
FROM ubuntu:latest

# Instale o servidor SSH
RUN apt-get update && apt-get install -y openssh-server && mkdir /var/run/sshd

# Configure o SSH para permitir login root com senha
RUN echo 'root:minha_senha' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Alterar a porta do SSH para 2222
RUN sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config

# Exponha a nova porta para SSH
EXPOSE 2222

# Comando para iniciar o SSH
CMD ["/usr/sbin/sshd", "-D"]
