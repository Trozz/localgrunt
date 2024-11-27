output "connection_secret" {
  value = aws_secretsmanager_secret.rds.id
}

output "writer_endpoint" {
  value = module.aurora.cluster_endpoint
}

output "reader_endpoint" {
  value = module.aurora.cluster_reader_endpoint
}

output "cluster_port" {
  value = module.aurora.cluster_port
}

output "postgres_connection" {
  value = "postgresql://${module.aurora.cluster_endpoint}:${module.aurora.cluster_port}"
}
