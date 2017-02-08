#!/bin/bash

docker kill databox-cm
docker kill  databox-resolver
docker rm databox-cm
docker rm databox-resolver

#docker run -d --name databox-resolver \
#	 --hostname resolvable  \
#	 -v /var/run/docker.sock:/tmp/docker.sock \
#	 -v /etc/resolvconf/resolv.conf.d/head:/tmp/resolv.conf \
#	 mgood/resolvable

docker create \
	-v /var/run/docker.sock:/var/run/docker.sock \
        -v `pwd`:/cm \
        --name databox-cm \
	--label databox.type=container-manager \
        -e "DATABOX_DEV=1" \
	-p 8989:8989 \
        -t node:alpine npm --prefix /cm start

#	-t node:latest npm --prefix /cm start
#	-t node:argon --prefix /cm start
#        -t mhart/alpine-node npm --prefix /cm start

docker network connect databox-cloud-net databox-cm
docker network connect databox-app-net databox-cm
docker network connect databox-driver-net databox-cm

docker start -i databox-cm