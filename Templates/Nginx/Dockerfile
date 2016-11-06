FROM ubuntu:16.04
MAINTAINER Barend Erasmus developersworkspace@gmail.com
RUN apt-get update
RUN apt-get install -y nginx
COPY src/nginx.conf /etc/nginx/nginx.conf
CMD ["nginx"] 
