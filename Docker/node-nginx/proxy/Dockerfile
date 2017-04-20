FROM alpine:latest
MAINTAINER phu.le.dev@gmail.com

RUN apk add --update nginx bash && mkdir /run/nginx
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./conf.d /etc/nginx/conf.d

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/nginx"]
