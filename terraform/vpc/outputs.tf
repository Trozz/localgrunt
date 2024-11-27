output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "intra_subnets" {
  value = module.vpc.intra_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "name" {
  value = local.name
}

output "cidr" {
  value = var.cidr
}
