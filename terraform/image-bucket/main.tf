data "aws_caller_identity" "current" {}

locals {
  bucket_prefix = "trozz-${data.aws_caller_identity.current.account_id}"
}


module "cloudfront-bucket" {
  source = "./module/terraform-aws-cloudfront-bucket"

  bucket_name = var.bucket_name == "" ? "${local.bucket_prefix}-email-images" : var.bucket_name

}
