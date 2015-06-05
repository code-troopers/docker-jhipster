FROM debian:8

MAINTAINER Cedric Gatay "c.gatay@code-troopers.com"
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y -q git curl sudo openssh-server zip bzip fontconfig vim && \
    mkdir /var/run/sshd && \
    apt-get clean && \
    rm -rf /var/lib/dpkg/info/* && \
    rm -rf /var/lib/apt

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
    echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
    apt-get update && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections &&\
    apt-get -y install oracle-java8-installer && \
    apt-get clean && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    rm -rf /usr/lib/jvm/java-8-oracle/lib/visualvm && \
    rm -rf /usr/lib/jvm/java-8-oracle/lib/missioncontrol &&\
    rm -rf /var/lib/dpkg/info/* &&\
    rm -rf /var/lib/apt

# Set oracle java as the default java
RUN update-java-alternatives -s java-8-oracle
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV MAVEN_VERSION 3.3.3
RUN curl -sL ftp://mirror.reverse.net/pub/apache/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz | tar xzf - -C /opt && \
    ln -s /opt/apache-maven-$MAVEN_VERSION/bin/mvn /usr/bin/mvn

RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash - && \
    apt-get -y install nodejs && \
    apt-get clean &&\
    rm -rf /var/lib/dpkg/info/* &&\
    rm -rf /var/lib/apt

# Install bower and grunt 
RUN npm install -g bower grunt grunt-cli karma-cli 

# configure the "jhipster" and "root" users
RUN echo 'root:jhipster' |chpasswd && \
    groupadd jhipster && useradd jhipster -s /bin/bash -m -g jhipster -G jhipster && adduser jhipster sudo && \
    echo 'jhipster:jhipster' |chpasswd

USER jhipster
VOLUME ["/home/jhipster"]
WORKDIR /home/jhipster
EXPOSE 8080 3000 3001 22
CMD ["/usr/sbin/sshd", "-D"]