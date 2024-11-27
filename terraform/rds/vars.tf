variable "aws_region" {
  description = "The region to deploy to"
  default     = "eu-west-2"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  default     = {}
  type        = map(string)
}

variable "engine_version" {
  description = "The version of the RDS engine"
  default     = "14.5"
  type        = string
}

variable "instance_class" {
  description = "The instance class to use for the RDS instance"
  default     = "db.t3.small"
  type        = string
}

variable "autoscaling_max_capacity" {
  description = "The maximum number of instances in the autoscaling group"
  default     = 2
  type        = number
}

variable "node_security_group_id" {
  description = "The security group ID for the EKS nodes"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "backup_retention_period" {
  description = "The number of days to retain backups for"
  default     = 1827 # 5 years
  type        = number
}

variable "database_subnets" {
  description = "The subnets to deploy the RDS instance into"
  type        = list(string)
}

variable "apply_immediately" {
  description = "Whether to apply changes immediately or wait for the next maintenance window"
  default     = false
  type        = bool
}

variable "auto_minor_version_upgrade" {
  description = "Whether to automatically upgrade to the latest minor version"
  default     = true
  type        = bool
}

variable "allow_major_version_upgrade" {
  description = "Whether to allow major version upgrades"
  default     = false
  type        = bool
}
