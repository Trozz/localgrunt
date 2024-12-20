resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = merge(var.default_tags, var.s3_bucket_tags)
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

    condition {
      variable = "aws:SourceArn"
      test     = "StringEquals"
      values   = [aws_cloudfront_distribution.this.arn]
    }
  }

  statement {
    sid = "BucketSecureTransport"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    effect = "Deny"

    actions   = ["s3:*"]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
      "${aws_s3_bucket.this.arn}"
      ]

    condition {
      variable = "aws:SecureTransport"
      test     = "Bool"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = data.aws_iam_policy_document.bucket_policy.json
}
