#!/bin/bash

function master {
    echo "Master Init"
}

function node {
    echo "Node Init called from $1"
    
    chmod +x /tmp/yq
    chmod +x /tmp/rclone

    /tmp/rclone copy /master/init_sync/ /data/ --update --progress --checksum -v

    # Debug ToDo: Remove before release
    apt-get install tree -y -qq > /dev/null
    tree .
    sleep 5
    # END DEBUG

    /tmp/yq e ".master-connection.my-name = \"crowned-${1}\"" -i /data/multipaper.yml # set node name.#
    /tmp/yq e ".proxies.velocity.enabled = true" -i /data/config/paper-global.yml
    /tmp/yq e ".proxies.velocity.online-mode = true" -i /data/config/paper-global.yml
    /tmp/yq e ".proxies.velocity.secret = \"$(cat /data/config/forwarding.secret)\"" -i /data/config/paper-global.yml

    chmod -R 777 /data/
}

if [ -z "$(ls /data/*.jar 2>/dev/null)" ]; then
    exit 0
fi

if [ "$1" == "master" ]; then
    master
else
    node $1
fi