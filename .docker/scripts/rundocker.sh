#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' ./.env | xargs)


# Remove old containers
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
docker volume rm $(docker volume ls -q)

# Build app
docker compose build
docker compose up -d
docker exec -it ${APP_NAME}_php-fpm composer u --no-cache
docker exec -it ${APP_NAME}_php-fpm php artisan migrate:fresh --seed

#Run all tests - optional
#docker exec -it ${APP_NAME}_php-fpm php artisan test

docker exec -it ${APP_NAME,,}_php-fpm bash