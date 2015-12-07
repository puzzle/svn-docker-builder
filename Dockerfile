FROM registry.access.redhat.com/openshift3/ose-docker-builder:latest
MAINTAINER Daniel Tschan <tschan@puzzle.ch>

RUN yum -y --disablerepo=* --enablerepo=rhel-7-server-rpms --enablerepo=rhel-7-server-extras-rpms --enablerepo=rhel-7-server-optional-rpms install docker-1.6.2 subversion; yum clean all

ADD ./build.sh /tmp/build.sh

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["/tmp/build.sh"]
