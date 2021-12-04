FROM harbor.example.com/library/alpine:3.13

MAINTAINER ringo

ENV TZ "Asia/Shanghai"

RUN sed -ri 's+dl-cdn.alpinelinux.org+mirrors.aliyun.com+g' /etc/apk/repositories \
 && apk add --no-cache curl tzdata ca-certificates \
 && cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && apk upgrade \
 && rm -rf /var/cache/apk/*

COPY kubectl /usr/local/bin/
RUN chmod +x /usr/local/bin/kubectl

ENTRYPOINT ["kubectl"]
CMD ["help"]