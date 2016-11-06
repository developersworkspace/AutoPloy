FROM ubuntu:16.04
MAINTAINER Barend Erasmus developersworkspace@gmail.com

RUN apt-get update
RUN apt-get install -y default-jre
RUN apt-get install -y default-jdk
ADD http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war
ENV JENKINS_HOME /jenkins

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]
EXPOSE 8080