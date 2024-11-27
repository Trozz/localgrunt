# Repo for Localstack

## Requirements

- Terragrunt
- Terraform
- Localstack
- tflocal
- awscli

## Usage

```shell
cat <<EOF >> ~/.aws/config
[default]
region = eu-west-2
endpoint_url = http://localhost.localstack.cloud:4566
EOF

cat <<EOF >> ~/.aws/credentials
[default]
aws_access_key_id = test
aws_secret_access_key = test
EOF

cd aws/localstack/demo/vpc
terragrunt apply --terragrunt-tfpath tflocal
```