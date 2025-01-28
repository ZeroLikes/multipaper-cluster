# !/bin/bash

echo "Removing old Containers"
docker kill multipaper-node-1-1
docker kill multipaper-node-2-1
docker kill multipaper-master-1
docker kill multipaper-mongodb-1

docker rm multipaper-node-1-1
docker rm multipaper-node-2-1
docker rm multipaper-master-1
docker rm multipaper-mongodb-1
echo "======================================================="

sleep 3

echo "Removing all node directories"
rm -rfv node-*
echo "======================================================="

echo "Removing master directory"
rm -rfv master/*
echo "======================================================="

echo "Copying master_template to master"
cp -f -r -v master_template/* master/
echo "======================================================="

echo "Setting permission 777"
chmod -R 777 /srv/minecraft/multipaper/*

echo "Starting docker compose"
docker compose up -d --remove-orphans