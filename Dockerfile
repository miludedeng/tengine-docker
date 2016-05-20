FROM debian:jessie
MAINTAINER Steven "hw@zving.com"

ENV TENGINE_VERSION 2.1.2

ENV DEBIAN_FRONTEND noninteractive

RUN rm -rf /etc/apt/sources.list\
        && touch /etc/apt/sources.list\
        && echo 'deb http://mirrors.ustc.edu.cn/debian stable main contrib non-free' >> /etc/apt/sources.list\
        && echo 'deb-src http://mirrors.ustc.edu.cn/debian stable main contrib non-free' >> /etc/apt/sources.list\
        && echo 'deb http://mirrors.ustc.edu.cn/debian stable-proposed-updates main contrib non-free' >> /etc/apt/sources.list\
        && echo 'deb-src http://mirrors.ustc.edu.cn/debian stable-proposed-updates main contrib non-free' >> /etc/apt/sources.list\
        && apt-get update \
        && apt-get install -y wget gcc libssl-dev libpcre3-dev make
RUN adduser --disabled-login --gecos 'Tengine' nginx

WORKDIR /home/nginx

RUN wget http://tengine.taobao.org/download/tengine-$TENGINE_VERSION.tar.gz\
    && tar zxvf tengine-$TENGINE_VERSION.tar.gz\
    && rm tengine-$TENGINE_VERSION.tar.gz\
    && cd tengine-$TENGINE_VERSION\
    && ./configure && make && make install
WORKDIR /home/nginx/tengine-$TENGINE_VERSION
RUN apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/nginx/*

WORKDIR /usr/local/nginx/sbin/

EXPOSE 80
EXPOSE 443

CMD ["./nginx","-g","daemon off;"]