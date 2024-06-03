#!/bin/bash

# Deploy using Helm charts
helm install frontend ../helm/frontend
helm install backend ../helm/backend
helm install mysql ../helm/mysql
