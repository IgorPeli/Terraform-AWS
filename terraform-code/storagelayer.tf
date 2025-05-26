resource "aws_s3_bucket" "wordpress_media" {
  bucket        = "wp-media-${random_id.bucket_suffix.hex}"
  force_destroy = true
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}



#Role para acessar o s3
resource "aws_iam_policy" "s3_upload_policy" {
  name = "ecs-s3-upload-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = "${aws_s3_bucket.wordpress_media.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_s3_upload" {
  role       = aws_iam_role.ecsExecution.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}
