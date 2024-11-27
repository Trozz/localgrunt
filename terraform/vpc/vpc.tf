module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"

  name = "${local.name}-vpc"
  cidr = var.cidr

  manage_default_vpc            = true
  manage_default_security_group = true
  manage_default_route_table    = true
  manage_default_network_acl    = true

  azs              = local.azs
  private_subnets  = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k)]
  public_subnets   = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 4)]
  database_subnets = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 8)]
  intra_subnets    = [for k, v in local.azs : cidrsubnet(var.cidr, 8, k + 12)]



  enable_nat_gateway     = true
  single_nat_gateway     = var.single_nat_gateway == "true" ? true : false
  one_nat_gateway_per_az = var.single_nat_gateway == "true" ? false : true
  enable_vpn_gateway     = false

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }


}

module "endpoints" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "5.13.0"

  vpc_id                = module.vpc.vpc_id
  create_security_group = true

  endpoints = {
    s3 = {
      # interface endpoint
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    },
    ecr-api = {
      service         = "ecr.api"
      route_table_ids = module.vpc.private_route_table_ids
      tags            = { Name = "ecr-api-vpc-endpoint" }
    }
    ecr-dkr = {
      service         = "ecr.dkr"
      route_table_ids = module.vpc.private_route_table_ids
      tags            = { Name = "ecr-dkr-vpc-endpoint" }
    }
  }
}
