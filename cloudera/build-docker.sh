#!/bin/bash

set -ex

rm -rf docker-tmp

mkdir docker-tmp
cp cloudera/* docker-tmp
cp zookeeper-assembly/target/apache-zookeeper-*-bin.tar.gz docker-tmp

if [ -z "$REGISTRY" ]; then
  REGISTRY=${REGISTRY:-"docker-private.infra.cloudera.com/cloudera"}
fi

docker build -t ${REGISTRY}/zookeeper:$GBN \
    ./docker-tmp
#docker push ${REGISTRY}/zookeeper:$GBN

rm -rf docker-tmp
