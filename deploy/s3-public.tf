resource "aws_s3_bucket" "bucket" {
  bucket = "snowflake-s3-sfc-demo-ep"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_iam_policy" "bucket_policy" {
  name        = "snowflake-s3-sfc-demo-ep-policy"
  description = "Policy for bucket snowflake-s3-sfc-demo-ep"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "s3:GetObject",
              "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::snowflake-s3-sfc-demo-ep/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::snowflake-s3-sfc-demo-ep",
            "Condition": {
                "StringLike": {
                    "s3:prefix": [
                        "*"
                    ]
                }
            }
        }
    ]
}
EOF
}

resource "aws_iam_role" "bucket_role" {
  name = "snowflake-s3-sfc-demo-ep-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "role-policy-attach" {
  name       = "test-attachment"
  roles      = [aws_iam_role.bucket_role.name]
  policy_arn = aws_iam_policy.bucket_policy.arn
}