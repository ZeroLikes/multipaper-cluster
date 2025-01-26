#!/bin/bash

function master {
    echo "Master Init"
}

function slave {
    echo "Slave Init called from $1"
    
    chmod +x /tmp/yq
    chmod +x /tmp/rclone

    /tmp/yq e '.settings.bungeecord = true' -i /data/spigot.yml
    /tmp/yq e ".master-connection.my-name = \"crowned-${1}\"" -i /data/multipaper.yml

    /tmp/rclone sync /master/init_sync/plugins /data/plugins --update --progress

    chmod -R 777 /data/
}

if [ -z "$(ls /data/*.jar 2>/dev/null)" ]; then
    exit 0
fi

if [ "$1" == "master" ]; then
    master
else
    slave $1
fi