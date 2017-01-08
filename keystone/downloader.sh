#!/bin/bash -eux

export REPO="samyaple/openstack-requirements"
export TOKEN=$(curl "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${REPO}:pull" | python -c "import sys, json; print json.load(sys.stdin)['token']")
export BLOB=$(curl -H "Authorization: Bearer ${TOKEN}" https://registry.hub.docker.com/v2/${REPO}/manifests/latest | python -c "import sys, json; print json.load(sys.stdin)['fsLayers'][1]['blobSum']")

curl -L -H "Authorization: Bearer ${TOKEN}" https://registry.hub.docker.com/v2/${REPO}/blobs/${BLOB} > /tmp/wheels.tar.gz

mkdir /tmp/packages
tar xvf /tmp/wheels.tar.gz -C /tmp/packages/ --strip-components=2 root/packages
