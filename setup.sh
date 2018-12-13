#!/usr/bin/env bash

mv .env.example .env

mv .env.db.example .env.db

mkdir data

docker-compose -f docker-compose.yml -f docker-compose.local.yml --no-cache --rm build
