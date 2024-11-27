variable "aws_region" {
  description = "The region to deploy to"
  default     = "eu-west-2"
  type        = string
}

variable "environment" {
  description = "The environment to deploy to"
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
  type        = string
}

variable "single_nat_gateway" {
  description = "Whether to use a single NAT gateway"
  default     = "true"
  type        = bool
}

variable "tags" {
  description = "Tags to apply to all resources"
  default     = {}
  type        = map(string)
}

variable "using_localstack" {
  description = "Whether to use Localstack"
  default     = false
  type        = bool
}