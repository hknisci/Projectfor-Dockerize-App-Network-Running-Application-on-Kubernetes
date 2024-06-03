#!/bin/bash

# Start Minikube or k3d
minikube start
# k3d cluster create mycluster

# Apply Kubernetes configurations
kubectl apply -f ../k8s/frontend-deployment.yaml
kubectl apply -f ../k8s/backend-deployment.yaml
kubectl apply -f ../k8s/mysql-deployment.yaml
kubectl apply -f ../k8s/frontend-service.yaml
kubectl apply -f ../k8s/backend-service.yaml
kubectl apply -f ../k8s/mysql-service.yaml
