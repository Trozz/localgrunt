terraform {
  source = "../../../../terraform/image-bucket"
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
  aws_region  = local.account_vars.aws_region
  environment = local.environment_vars.environment

  tags = {
    "provisioning-source" = get_path_from_repo_root()
  }
}
