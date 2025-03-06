#!/bin/bash

# Stop and remove containers, networks, images, and volumes
docker-compose down

# Build, (re)create, start, and attach to containers for a service
docker compose up -d --build
