# Dockerfile for Wopi Server
#
# Please, build and run via docker-compose file: wopiserver.yaml


FROM cern/cc7-base

LABEL maintainer="cernbox-admins@cern.ch" name="wopiserver: The CERNBox WOPI server" version="1.0"

MAINTAINER Michael D'Silva <md@aarnet.edu.au>

COPY scripts/* /scripts/
COPY wopiserver.d/repos/xrootd.repo /etc/yum.repos.d/
#if you are missing some repos
#COPY wopiserver.d/repos/*repo /etc/yum.repos.d/

ADD cernbox-wopi*rpm /tmp

RUN yum -y install \
	sudo \
	python-flask \
	python-jwt \
        curl

RUN yum -y install --disablerepo=epel \
	xrootd-client \
	xrootd-python \
        /tmp/cernbox-wopi*rpm

COPY wopiserver.d/* /etc/wopi/
RUN mkdir /etc/certs
ADD ./etc/*.pem /etc/certs/
VOLUME ['/var/log/wopi']

#CMD /scripts/entrypoint
CMD ["python", "/usr/bin/wopiserver.py"]
