#!/usr/bin/env bash

echo USERNAME=`whoami` >> .env
echo UID=`id -u` >> .env
echo GID=`id -g` >> .env

mv .env.db.example .env.db

mkdir data

docker-compose -f docker-compose.yml -f docker-compose.local.yml --no-cache --rm build
