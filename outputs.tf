output "rds_endpoint" {
  description = "El endpoint de la base de datos para conectar la App"
  value       = aws_db_instance.postgres.endpoint
}

output "cluster_name" {
  description = "Nombre del cluster EKS"
  value       = module.eks.cluster_name
}