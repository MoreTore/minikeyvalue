FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# system basics
RUN apt-get update && \
  apt-get -y --no-install-recommends install \
    build-essential \
    curl \
    python3 \
    python3-dev \
    python3-setuptools \
    python3-pip \
    libffi-dev \
    nginx \
    golang \
    git && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /
ENV GOPATH /go
ENV PATH ${PATH}:/mkv

RUN go get -u github.com/google/uuid
RUN go get -u github.com/syndtr/goleveldb/leveldb
RUN go get -u github.com/syndtr/goleveldb/leveldb/util

COPY requirements.txt mkv/requirements.txt
RUN pip3 install --no-cache-dir -r mkv/requirements.txt

COPY mkv volume mkv/
COPY src/*.go mkv/src/
COPY tools/* mkv/tools/
RUN chmod +x /mkv/tools/bringup.sh
WORKDIR /mkv
ENTRYPOINT ["./tools/bringup.sh"]
