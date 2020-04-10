FROM debian:latest
MAINTAINER MELBEIED

#Update apt-get
RUN apt-get update -yq
RUN apt-get install software-properties-common -yq

#Install vim text editor
RUN apt-get install -yq vim

#Install ssh server
RUN apt install -yq openssh-server
RUN sed  -i -e 's/^#Port.*$/Port 22/g' /etc/ssh/sshd_config
RUN sed  -i -e 's/^#PermitRootLogin.*$/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN echo 'root:1234567890' | chpasswd
EXPOSE 22


#Install Nginx web server
RUN DEBIAN_FRONTEND=noninteractive apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq install net-tools nginx && \
    useradd -ms /bin/bash nginx && \
    rm -f /etc/nginx/fastcgi.conf /etc/nginx/fastcgi_params && \
    rm -f /etc/nginx/snippets/fastcgi-php.conf /etc/nginx/snippets/snakeoil.conf
EXPOSE 80
#EXPOSE 443
#COPY nginx/ssl /etc/nginx/ssl
#COPY nginx/snippets /etc/nginx/snippets
#COPY nginx/sites-available /etc/nginx/sites-available

# Set the entry point to start services
ENTRYPOINT service ssh restart && nginx -g 'daemon off;'