FROM ubuntu:16.04
MAINTAINER Barend Erasmus developersworkspace@gmail.com
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' > /etc/apt/sources.list.d/mongodb.list
RUN apt-get update
RUN apt-get install -y mongodb-org
RUN mkdir -p /data/db
COPY src/mongod.conf /mongod.conf
CMD ["/usr/bin/mongod","-f","/mongod.conf"] 
