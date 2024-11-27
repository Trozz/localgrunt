resource "random_string" "username" {
  length  = 16
  special = false
}

resource "aws_secretsmanager_secret" "rds" {
  name = "${var.environment}/aurora/rds"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    postgres_connection = "postgresql://${module.aurora.cluster_endpoint}:${module.aurora.cluster_port}",
    postgres_port       = module.aurora.cluster_port,
    writer_endpoint     = module.aurora.cluster_endpoint,
    reader_endpoint     = module.aurora.cluster_reader_endpoint
  })
}

resource "aws_kms_key" "rds" {
  description             = "KMS key for RDS"
  deletion_window_in_days = 10
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "Enable IAM User Permissions",
        Effect = "Allow",
        Principal = {
          AWS = "*"
        },
        Action   = "kms:*",
        Resource = "*"
      }
    ]
  })
}

data "aws_availability_zones" "available" {}

module "aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "9.10.0"

  name = local.name

  engine         = "aurora-postgresql"
  engine_version = var.engine_version

  instance_class = var.instance_class
  instances      = { 1 = {} }

  master_username             = random_string.username.result
  manage_master_user_password = true

  availability_zones = data.aws_availability_zones.available.names

  backup_retention_period = var.backup_retention_period

  vpc_id = var.vpc_id
  security_group_rules = {
    eks_ingress = {
      source_security_group_id = var.node_security_group_id
    }
  }

  autoscaling_enabled      = true
  autoscaling_min_capacity = 0
  autoscaling_max_capacity = var.autoscaling_max_capacity

  monitoring_interval           = 60
  iam_role_name                 = "${local.name}-monitor"
  iam_role_description          = "${local.name} RDS enhanced monitoring IAM role"
  iam_role_path                 = "/autoscaling/"
  iam_role_max_session_duration = 7200

  cluster_performance_insights_enabled          = true
  cluster_performance_insights_retention_period = 7

  copy_tags_to_snapshot = true

  create_cloudwatch_log_group = true
  # create_db_cluster_activity_stream = true
  create_db_cluster_parameter_group           = true
  db_cluster_db_instance_parameter_group_name = "${local.name}-db-cluster-parameter-group-aurora-postgresql${split(".", var.engine_version)[0]}"
  db_cluster_parameter_group_family           = "aurora-postgresql${split(".", var.engine_version)[0]}"
  db_cluster_parameter_group_parameters = [{
    name  = "rds.logical_replication"
    value = "1"
    apply_method = "pending-reboot"
  }]

  enable_local_write_forwarding = true # Enable write operations to read replicas then forward them to the writer instance
  # create_db_parameter_group = true
  create_db_subnet_group = true
  subnets                = var.database_subnets

  iam_database_authentication_enabled = true

  kms_key_id        = aws_kms_key.rds.arn
  storage_encrypted = true

  apply_immediately           = var.apply_immediately
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  skip_final_snapshot         = true



  enabled_cloudwatch_logs_exports = ["postgresql"]
}
