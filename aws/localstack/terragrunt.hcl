remote_state {
  backend = "s3"

  config = {
    encrypt               = tobool(get_env("USE_LOCALSTACK", "false")) ? false : true
    endpoint              = tobool(get_env("USE_LOCALSTACK", "false")) ? "http://s3.localhost.localstack.cloud:4566" : "https://s3.amazonaws.com" 
    dynamodb_endpoint      = tobool(get_env("USE_LOCALSTACK", "false")) ? "http://localhost.localstack.cloud:4566" : "https://dynamodb.amazonaws.com"
    sts_endpoint      = tobool(get_env("USE_LOCALSTACK", "false")) ? "http://localhost.localstack.cloud:4566" : "https://sts.amazonaws.com"
    #bucket                = "trozz-${get_aws_account_id()}-tfstate"
    bucket                = "trozz-tfstate"
    key                   = "${path_relative_to_include()}/terraform.tfstate"
    region                = "eu-west-2"
    disable_bucket_update = true
    dynamodb_table        = "TerraformStateLocks"

    # Skip the following if you are using Localstack
    skip_credentials_validation = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_bucket_versioning = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_bucket_ssencryption = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_bucket_accesslogging = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_bucket_root_access = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_bucket_enforced_tls = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_bucket_public_access_blocking = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_accesslogging_bucket_acl = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_accesslogging_bucket_enforced_tls = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_accesslogging_bucket_public_access_blocking = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false
    skip_accesslogging_bucket_ssencryption = tobool(get_env("USE_LOCALSTACK", "false")) ? true : false

  }

}

inputs = merge(
  yamldecode(file(find_in_parent_folders("global.yaml"))),
  yamldecode(file(find_in_parent_folders("account.yaml")))
)
