FROM alpine:3.5

MAINTAINER Jérémy Baumgarth

# Install nginx and php
RUN apk update && \
    apk upgrade && \
    apk add --update openssl nginx && \
    mkdir /run/nginx && \
    mkdir /etc/nginx/certificates && \
    openssl req \
        -x509 \
        -newkey rsa:2048 \
        -keyout /etc/nginx/certificates/key.pem \
        -out /etc/nginx/certificates/cert.pem \
        -days 365 \
        -nodes \
        -subj /CN=localhost && \
    rm -rf /var/cache/apk/*

# add user www-data
RUN adduser -S www-data

# Nginx configuration
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx/conf.d/ /etc/nginx/conf.d/

# Default pages
COPY src/ /var/www/

# init script
COPY init_script.sh /init_script.sh
RUN chmod +x /init_script.sh

CMD ["/bin/sh", "/init_script.sh"]
