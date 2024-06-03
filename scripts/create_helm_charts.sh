#!/bin/bash

set -e

# Function to create a Helm chart
create_chart() {
  local name=$1
  local image=$2
  local port=$3
  local nodePort=$4
  local replicas=$5
  local resources=$6

  mkdir -p ../helm/$name/templates

  # Create Chart.yaml
  cat <<EOF > ../helm/$name/Chart.yaml
apiVersion: v2
name: $name
description: A Helm chart for Kubernetes
version: 0.1.0
appVersion: "1.0"
EOF

  # Create values.yaml
  cat <<EOF > ../helm/$name/values.yaml
replicaCount: $replicas

image:
  repository: $image
  tag: latest
  pullPolicy: IfNotPresent

service:
  type: NodePort
  port: $port
  nodePort: $nodePort

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

nodeSelector: {}

tolerations: []

affinity: {}
EOF

  # Create deployment.yaml
  cat <<EOF > ../helm/$name/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "$name.fullname" . }}
  labels:
    {{- include "$name.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "$name.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "$name.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.service.port }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
EOF

  # Create service.yaml
  cat <<EOF > ../helm/$name/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "$name.fullname" . }}
  labels:
    {{- include "$name.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.port }}
      nodePort: {{ .Values.service.nodePort | default nil }}
  selector:
    {{- include "$name.selectorLabels" . | nindent 4 }}
EOF
}

# Create frontend Helm chart
create_chart "frontend" "localhost:5000/frontend" 3000 30001 2 "resources"

# Create backend Helm chart
create_chart "backend" "localhost:5000/backend" 5000 30002 2 "resources"

# Create MySQL Helm chart
mkdir -p ../helm/mysql/templates

cat <<EOF > ../helm/mysql/Chart.yaml
apiVersion: v2
name: mysql
description: A Helm chart for Kubernetes
version: 0.1.0
appVersion: "5.7"
EOF

cat <<EOF > ../helm/mysql/values.yaml
replicaCount: 1

image:
  repository: mysql
  tag: 5.7
  pullPolicy: IfNotPresent

mysqlRootPassword: example
mysqlDatabase: exampledb
mysqlUser: user
mysqlPassword: password

service:
  type: ClusterIP
  port: 3306

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

nodeSelector: {}

tolerations: []

affinity: {}
EOF

cat <<EOF > ../helm/mysql/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mysql.fullname" . }}
  labels:
    {{- include "mysql.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "mysql.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "mysql.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: {{ .Values.mysqlRootPassword }}
            - name: MYSQL_DATABASE
              value: {{ .Values.mysqlDatabase }}
            - name: MYSQL_USER
              value: {{ .Values.mysqlUser }}
            - name: MYSQL_PASSWORD
              value: {{ .Values.mysqlPassword }}
          ports:
            - containerPort: {{ .Values.service.port }}
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
EOF

cat <<EOF > ../helm/mysql/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ include "mysql.fullname" . }}
  labels:
    {{- include "mysql.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.port }}
  selector:
    {{- include "mysql.selectorLabels" . | nindent 4 }}
EOF

echo "Helm charts created successfully."
