This module is responsible for creating the Load Balancer EC2 instance on nginx. It creates the following resources:

- Public subnet for LD
- Elastic IP for LB and NAT gateway
- Security groups to allow specific trafic
- Nginx Load Balancer EC2 instance
- It uses datasources of existing VPC/Jenkins security group/IGW
- It uses `iam_instance_profile` from iam module to pass rules for SSM
