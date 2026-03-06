terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1" # Altere para a sua região de preferência
  # O Terraform usará seu perfil configurado localmente que aponta para a conta 017121235801
}

# Definição do Cluster ECS
resource "aws_ecs_cluster" "infra_devops" {
  name = "infra-devops"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Environment = "Dev"
    Project     = "Infra-DevOps"
  }
}

# Configuração de Capacidade (Fargate)
resource "aws_ecs_cluster_capacity_providers" "example" {
  cluster_name = aws_ecs_cluster.infra_devops.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}