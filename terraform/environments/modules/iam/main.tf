#IAM role policy for webapp to have acces to S3 bucket and SSM
resource "aws_iam_role" "webapp_role" {
  name = "${var.environment}-webapp-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.environment}-s3-access-policy"
  description = "Allows read/write access to the pictures S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Effect   = "Allow",
        Resource = "${var.s3_bucket_pictures_arn}/*"
      },
      {
        Action   = "s3:ListBucket",
        Effect   = "Allow",
        Resource = var.s3_bucket_pictures_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.webapp_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

#SSM manager additinal policy
resource "aws_iam_role_policy_attachment" "webapp_ssm_attachment" {
  role       = aws_iam_role.webapp_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "webapp_profile" {
  name = "${var.environment}-webapp-profile"
  role = aws_iam_role.webapp_role.name
}

#Using existing SSM manager role to attach for all instances 
data "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ec2-ssm-instance-profile"
}