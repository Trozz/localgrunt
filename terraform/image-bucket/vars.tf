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

variable "bucket_name" {
  description = "The name of the bucket to create"
  type        = string
  default     = ""
}
