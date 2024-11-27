include {
  path = find_in_parent_folders()
}

locals {
  global_vars      = yamldecode(file(find_in_parent_folders("global.yaml")))
  account_vars     = yamldecode(file(find_in_parent_folders("account.yaml")))
  environment_vars = yamldecode(file(find_in_parent_folders("env.yaml")))
}

dependency "vpc" {
  config_path = find_in_parent_folders("vpc")
}

terraform {
    source  = "tfr:///terraform-aws-modules/eks/aws?version=20.0.0"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "s3" {}
}
provider "aws" {
  region = "${local.account_vars.aws_region}"
}
EOF
}

inputs = {
    bootstrap_self_managed_addons = false
    cluster_name    = "terragrunt-cluster"
    cluster_version = "1.29"
    cluster_endpoint_public_access  = true
    cluster_addons = {
        coredns = {
            most_recent = true
        }
        kube-proxy = {
            most_recent = true
        }
        vpc-cni = {
            most_recent = true
        }
    }
    vpc_id                   = dependency.vpc.outputs.vpc_id
    subnet_ids               = dependency.vpc.outputs.private_subnets
    # EKS Managed Node Group(s)
    eks_managed_node_group_defaults = {
        instance_types = ["t2.micro"]
    }
    eks_managed_node_groups = {
        example = {
        min_size     = 1
        max_size     = 1
        desired_size = 1
        instance_types = ["t3.micro"]
        capacity_type  = "SPOT"
        }
    }
    tags = {
        Environment = "dev"
        Terraform   = "true"
        Terragrunt  = "true"
    }
}