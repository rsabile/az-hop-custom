#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR
buildenv=${1:-local}

tag=$(date +"%g%m.%d%H")
case "$buildenv" in
    "github")
        hpcrover="hpcrover:${tag}"
        latest="hpcrover:latest"
    ;;

    "local")
        hpcrover="hpcrover:${tag}"
    ;;
esac


echo "Creating version ${hpcrover}"

# Build the base image
docker-compose build 

docker tag toolset_hpcrover ${hpcrover}
docker tag toolset_hpcrover ${latest}
case "$buildenv" in
    "github")
        #docker login
        docker push azhop.azurecr.io/${hpcrover}
        docker push azhop.azurecr.io/${latest}
    ;;

    "local")
    ;;
esac

echo "Version ${hpcrover} created."
popd