# the IAM Role that the EC2 instance will assume
resource "aws_iam_role" "ssm_role" {
  name = "ec2-ssm-role"

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

#AWS-managed policy for SSM to the role
resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#The instance profile to attach to the EC2 instance
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}


# EC2 inctance
resource "aws_instance" "ec2_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.SG_SubnetJenkins_id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name

  user_data = file("./modules/ec2/install_jenkins.sh")

  tags = {
    Name = var.service_name
  }
}