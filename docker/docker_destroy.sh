#!/bin/bash -e

if ! which docker 1>/dev/null 2>&1; then
    echo "Skip, since docker is not installed"
else
    if ! sudo service docker status 1>/dev/null 2>&1; then
        echo "Start docker daemon"
        sudo service docker start
    fi

    echo "Prepare to destroy all docker contianers"
    for container in $(sudo docker ps -a | grep -v '^CONTAINER' | awk -F' ' '{print $1}'); do
        echo "docker inspect $container"
        sudo docker inspect "$container"

        echo "Destroy container: $container."
        sudo docker stop "$container" || true
        sudo docker rm "$container" || true
    done

    echo "shutdown docker daemon"
    sudo service docker stop
fi
## File : docker_destroy.sh ends
