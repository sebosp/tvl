#!/bin/bash

if [[ "x" == "x$1" ]]; then
	>&2 "Missing main tag parameter. Usage: $0 tvl:0.0.X"
	exit 1;
fi
mainTag="$1"

docker tag $mainTag sebosp/$mainTag
docker tag $mainTag quay.io/sebosp/$mainTag
docker push sebosp/$mainTag
docker push quay.io/sebosp/$mainTag
