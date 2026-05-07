# ============================================================
# CONFIGURACIÓN BASE
# ============================================================

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
}

# Zonas de disponibilidad para que el cluster sea resiliente
data "aws_availability_zones" "available" {}


# ============================================================
# VPC
# ============================================================

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "jaime-eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  
  create_database_subnet_group = true # <--- ESTO ES VITAL
  database_subnets             = ["10.0.110.0/24", "10.0.111.0/24"] # Subredes para RDS
  # Vital para que los nodos privados salgan a internet
  enable_nat_gateway = true
  # Solo para dev/learning - en prod usar one_nat_gateway_per_az = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  # Tags requeridos por EKS para el autodescubrimiento de subnets
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }
}


# ============================================================
# EKS CLUSTER
# ============================================================

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.4" # Actualizado desde 19.15.3

  cluster_name    = "jaime-devops-cluster"
  cluster_version = "1.30" # Actualizado desde 1.27 (EOL)

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"] # Reemplaza con tu IP: ["X.X.X.X/32"]

  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API_AND_CONFIG_MAP"

  eks_managed_node_groups = {
    general = {
      desired_size = 2
      min_size     = 1
      max_size     = 3

      # K8s requiere más RAM que t2.micro
      instance_types = ["t3.medium"]
    }
  }
}
