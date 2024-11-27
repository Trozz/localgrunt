output "cloudfront_distribution" {
  value = module.cloudfront-bucket.cloudfront_distribution
}

output "bucket" {
  value = module.cloudfront-bucket.bucket
}
