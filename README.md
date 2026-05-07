# AWS EKS + RDS: Infraestructura Resiliente y Despliegue de Microservicio

Este proyecto demuestra el despliegue de una arquitectura de nube completa utilizando **Infraestructura como Código (IaC)**. Incluye la creación de una red segura, un cluster de Kubernetes gestionado y una base de datos relacional, validando la conectividad mediante un microservicio en Flask.



## 🚀 Arquitectura del Proyecto

- **Cloud Provider:** AWS
- **IaC:** Terraform (Módulos oficiales para VPC, EKS y RDS)
- **Orquestación:** Kubernetes (Amazon EKS v1.30)
- **Base de Datos:** Amazon RDS (PostgreSQL) en subredes privadas.
- **App:** Microservicio Flask (Python) con conectividad validada a base de datos.
- **Monitoreo:** Kubernetes Metrics Server para observabilidad.

## 🛠️ Stack Tecnológico

* **Terraform:** Gestión de VPC de 3 capas (Public, Private, Intra), Security Groups y recursos de AWS.
* **Kubernetes (kubectl):** Despliegue de Deployments y Services (LoadBalancer).
* **Python/Flask:** Aplicación para pruebas de conectividad de backend.
* **AWS CLI:** Gestión de identidades y acceso al cluster.

## 📋 Hitos de Ingeniería (SRE)

Durante este proyecto, se implementaron soluciones a retos comunes en entornos de producción:

1.  **Seguridad de Red:** Aislamiento de la base de datos en subredes privadas sin acceso a internet, permitiendo tráfico únicamente desde los nodos del cluster.
2.  **Gestión de Acceso IAM:** Configuración de *EKS Access Entries* para una gestión de permisos granular y moderna.
3.  **Resolución de DNS:** Configuración de `enable_dns_hostnames` y `enable_dns_support` para permitir que los Pods resuelvan endpoints de AWS.
4.  **Observabilidad:** Instalación y parcheo de seguridad del *Metrics Server* (`--kubelet-insecure-tls`) para monitoreo de recursos en tiempo real.

## 🚀 Guía de Despliegue

### 1. Infraestructura
```bash
cd terraform
terraform init
terraform apply -auto-approve# examplek8s
Despliegue de K8S en AWS
