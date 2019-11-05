FROM ubuntu
MAINTAINER Dirane (diranetafen@yahoo.com)
RUN apt-get update \
    && apt-get install -y nginx git
RUN rm -Rf /var/www/html/*
RUN git clone https://github.com/diranetafen/static-website-example.git /var/www/html/ \ 
    && sed -i 's/80 default_server/8080 default_server/g' /etc/nginx/sites-enabled/default 
EXPOSE 8080
ENTRYPOINT ["/usr/sbin/nginx","-g","daemon off;"]
