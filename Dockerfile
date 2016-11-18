FROM alpine:3.4

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

# init script
COPY init_script.sh /init_script.sh
RUN chmod +x /init_script.sh

# symlink stout to access log file, an stderr to error log file
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

CMD ["/bin/sh", "/init_script.sh"]
