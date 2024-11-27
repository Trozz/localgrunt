locals {
  global_vars  = yamldecode(file(find_in_parent_folders("global.yaml")))
  account_vars = yamldecode(file(find_in_parent_folders("account.yaml")))
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region              = "eu-west-2"
}
EOF
}

generate "module" {
  path      = "module.tf"
  if_exists = "overwrite"
  contents  = <<EOF
data "aws_caller_identity" "current" {}

locals {
    bucket_prefix = "localstack-$${data.aws_caller_identity.current.account_id}"
}

module "tfstate_backend" {
  source  = "cloudposse/tfstate-backend/aws"
  version = "1.5.0"

  force_destroy = true
  s3_bucket_name = "$${local.bucket_prefix}-tfstate"
  dynamodb_table_name = "TerraformStateLocks"
  bucket_ownership_enforced_enabled = true
}
EOF
}
