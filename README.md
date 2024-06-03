# Docker ve Kubernetes ile Uygulama Dağıtımı

Bu proje, Docker ve Kubernetes kullanarak basit bir frontend ve backend uygulamasının nasıl dağıtılacağını göstermektedir. Projede ayrıca Helm charts kullanarak uygulamaların kolayca yönetilmesi sağlanmıştır.

## Proje Yapısı

```
project/
│
├── frontend/
│   ├── Dockerfile
│   ├── package.json
│   ├── src/
│   │   ├── index.js
│   │   ├── App.js
│   │   └── index.css
│
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── index.js
│
├── db/
│   └── docker-compose.yml
│
├── k8s/
│   ├── frontend-deployment.yaml
│   ├── backend-deployment.yaml
│   ├── mysql-deployment.yaml
│   ├── frontend-service.yaml
│   ├── backend-service.yaml
│   └── mysql-service.yaml
│
├── helm/
│   ├── frontend/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
│   │   │   ├── deployment.yaml
│   │   │   └── service.yaml
│   ├── backend/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
│   │   │   ├── deployment.yaml
│   │   │   └── service.yaml
│   └── mysql/
│       ├── Chart.yaml
│       ├── values.yaml
│       ├── templates/
│       │   ├── deployment.yaml
│       │   └── service.yaml
│
└── scripts/
    ├── docker_build.sh
    ├── docker_compose_up.sh
    ├── k8s_deploy.sh
    ├── helm_deploy.sh
    └── create_helm_charts.sh
```

## Kurulum

### Gereksinimler

- Docker
- Docker Compose
- Kubernetes CLI (kubectl)
- Minikube veya k3d
- Helm

### Adımlar

1. **Proje deposunu klonlayın:**
   ```bash
   git clone https://github.com/kullanici_adi/proje_adi.git
   cd proje_adi
   ```

2. **Docker image'larını oluşturun ve yerel registry'ye push edin:**
   ```bash
   cd scripts
   chmod +x docker_build.sh
   ./docker_build.sh
   ```

3. **Docker Compose ile SQL Veritabanını çalıştırın:**
   ```bash
   chmod +x docker_compose_up.sh
   ./docker_compose_up.sh
   ```

4. **Kubernetes cluster'ını başlatın ve uygulamayı deploy edin:**
   ```bash
   chmod +x k8s_deploy.sh
   ./k8s_deploy.sh
   ```

5. **Helm charts oluşturmak için scripti çalıştırın:**
   ```bash
   chmod +x create_helm_charts.sh
   ./create_helm_charts.sh
   ```

6. **Helm ile uygulamayı deploy edin:**
   ```bash
   chmod +x helm_deploy.sh
   ./helm_deploy.sh
   ```
