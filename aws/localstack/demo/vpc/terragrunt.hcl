terraform {
  source = "../../../../terraform/vpc"
}

include {
  path = find_in_parent_folders()
}

locals {
  global_vars      = yamldecode(file(find_in_parent_folders("global.yaml")))
  account_vars     = yamldecode(file(find_in_parent_folders("account.yaml")))
  environment_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
}

inputs = {
  aws_region         = local.account_vars.aws_region
  environment        = local.environment_vars.environment
  cidr               = "10.30.0.0/16"
  single_nat_gateway = true

  # tags = {
  #   "provisioning-source" = get_path_from_repo_root()
  # }
}
