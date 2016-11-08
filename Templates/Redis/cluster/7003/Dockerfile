FROM ubuntu:16.04
MAINTAINER Barend Erasmus developersworkspace@gmail.com
RUN apt-get update
RUN apt-get install -y redis-server
RUN apt-get install -y tcl8.5
RUN apt-get install -y build-essential
RUN apt-get install -y wget
RUN apt-get install -y make
RUN wget http://download.redis.io/releases/redis-stable.tar.gz
RUN tar xzf redis-stable.tar.gz
WORKDIR redis-stable
RUN make
RUN make install
COPY src/redis.conf /redis.conf
CMD ["redis-server", "/redis.conf"]