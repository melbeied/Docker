FROM debian:latest
MAINTAINER OC


RUN echo 'Installation du serveur SSH'

RUN apt-get update -y
RUN apt-get install software-properties-common

RUN apt-get install -y vim

RUN apt install -y openssh-server
RUN sed  -i -e 's/^#Port.*$/Port 22/g' /etc/ssh/sshd_config
RUN sed  -i -e 's/^#PermitRootLogin.*$/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN echo 'root:1234567890' | chpasswd
EXPOSE 22


RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install net-tools nginx && \
    useradd -ms /bin/bash nginx && \
    rm -f /etc/nginx/fastcgi.conf /etc/nginx/fastcgi_params && \
    rm -f /etc/nginx/snippets/fastcgi-php.conf /etc/nginx/snippets/snakeoil.conf
EXPOSE 80
#EXPOSE 443
#COPY nginx/ssl /etc/nginx/ssl
#COPY nginx/snippets /etc/nginx/snippets
#COPY nginx/sites-available /etc/nginx/sites-available

ENTRYPOINT service ssh restart && nginx -g 'daemon off;'
#ENTRYPOINT ["/usr/sbin/nginx", "-g", "daemon off;"]
