FROM alpine:latest

ADD entrypoint.sh /opt/configure.sh

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod +x /opt/entrypoint.sh

ENTRYPOINT ["sh", "-c", "/opt/configure.sh"]
