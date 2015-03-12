FROM ubuntu
USER root
WORKDIR /tmp
RUN apt install -y curl git
RUN curl -L http://git.io/pdTu | sh
