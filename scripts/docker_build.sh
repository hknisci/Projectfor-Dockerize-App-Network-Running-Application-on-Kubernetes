#!/bin/bash

# Frontend build
docker build -t localhost:5000/frontend:latest ../frontend

# Backend build
docker build -t localhost:5000/backend:latest ../backend

# Push images to local registry
docker push localhost:5000/frontend:latest
docker push localhost:5000/backend:latest
docker push mysql:5.7
