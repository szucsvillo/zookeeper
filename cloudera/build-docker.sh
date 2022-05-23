#!/bin/bash

set -ex

rm -rf docker-tmp

mkdir docker-tmp
cp cloudera/* docker-tmp
cp zookeeper-assembly/target/apache-zookeeper-*-bin.tar.gz docker-tmp

json=`curl -s "https://release.infra.cloudera.com/hwre-api/imageinfo?project=BASE_IMAGE&image_name=ubi8/openjdk-11-runtime"`
tag=`echo $json | jq '[.[] | {tag: .image_tag, meta: .meta_id}] | sort_by(.meta) | last | .tag'`
tag=`sed -e 's/^"//' -e 's/"$//' <<< $tag`
sed -i "s/image_tag/$tag/g" docker-tmp/Dockerfile

if [ -z "$REGISTRY" ]; then
  REGISTRY=${REGISTRY:-"docker-private.infra.cloudera.com/cloudera"}
fi

docker build -t ${REGISTRY}/zookeeper:$GBN \
    ./docker-tmp
#docker push ${REGISTRY}/zookeeper:$GBN

rm -rf docker-tmp
