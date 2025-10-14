webapp_count               = "2"
public_subnet_cidr         = "10.0.11.0/24"
private_app_subnet_cidr    = "10.0.12.0/24"
private_db_subnet_cidr     = "10.0.13.0/24"
private_consul_subnet_cidr = "10.0.14.0/24"
ami_id                     = "ami-0f57cfecd0dc84ef0"
ami_id_db                  = "ami-0d3c68351da102c84"
igw_id                     = "igw-0ff63fe1fa109157a"

common_config = {
  environment       = "stage-01"
  availability_zone = "eu-central-1b"
  vpc_id            = "vpc-034d5a9addc2f04fe"
  jenkins_sg        = "sg-0d07356650954f12c"
  instance_type     = "t3.micro"
  key_name          = "ec2_key"
}