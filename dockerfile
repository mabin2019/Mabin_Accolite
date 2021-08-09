FROM docker-rt-interconnect.pruregistry.intranet.asia:8443/pru-flink:1.6.1.6

RUN mkdir /opt/flink/scripts/


COPY lib/*.jar /opt/flink/lib/

#Copying platform and platform-commons jars to lib folder
COPY jars/*.jar /opt/flink/lib/

RUN mkdir /opt/flink/state_dir
RUN mkdir /opt/flink/bin/tools
RUN mkdir -p /opt/flink/data/state
RUN mkdir /opt/flink/lib/linux-x86-64
RUN chown -R flink:flink /opt/flink/state_dir 
RUN chown -R flink:flink /opt/flink/bin/tools 
RUN chmod -R 755 /opt/flink/log/
RUN chown -R flink:flink /opt/flink/log
RUN chmod -R 755 /opt/flink/data/state
RUN chown -R flink:flink /opt/flink/data/state

COPY conf/* /opt/flink/conf/
COPY bin/* /opt/flink/bin/
COPY bin/tools/* /opt/flink/bin/tools/
COPY scripts/* /opt/flink/scripts/
COPY lib/linux-x86-64/* /opt/flink/lib/linux-x86-64/

RUN chown -R flink:flink /opt/flink/scripts/
RUN chown -R flink:flink /opt/flink/conf/
RUN chown -R flink:flink /opt/flink/bin/
RUN chown -R flink:flink /opt/flink/bin/tools/
RUN chown -R flink:flink /opt/flink/lib/
RUN chown -R flink:flink /opt/flink/lib/linux-x86-64/

RUN chmod -R 755 /opt/flink/lib/
RUN chmod 755 /opt/flink/bin/*
RUN chmod 755 /opt/flink/bin/tools/*
RUN chmod 755 /opt/flink/scripts/*.sh
RUN chmod -R 755 /opt/flink/conf/
RUN chmod -R 755 /opt/flink/lib/linux-x86-64/regolib.so

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 775 /docker-entrypoint.sh

ARG USER=flink
ARG UID=1000
ARG GID=1000

USER ${UID}:${GID}
WORKDIR /opt/${USER}
