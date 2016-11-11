FROM ubuntu:16.04
MAINTAINER Barend Erasmus developersworkspace@gmail.com

RUN apt-get update
RUN apt-get -y install build-essential libssl-dev libffi-dev python-dev
RUN apt-get -y install git
RUN apt-get -y install python3
RUN apt-get -y install python3-pip
RUN pip3 install Flask
RUN pip3 install gunicorn
RUN pip3 install pymongo
RUN pip3 install sendgrid
RUN pip3 install cryptography
RUN git clone https://developersworkspace:MidericK96@bitbucket.org/developersworkspace/openservices.git /repo
WORKDIR /repo/Source/OpenServices/OSAuthenticationUI
ENTRYPOINT ["/usr/local/bin/gunicorn", "-b", ":8080", "runserver:app"]