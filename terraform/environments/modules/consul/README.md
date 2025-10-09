This module is responsible for creating the Consul EC2 instance. It creates the following resources:

- Private subnet for consul
- Creates route table for consul and using dedicated enviroment NAT
- Security groups to allow specific trafic for consul ports
- EC2 instance
- It uses `iam_instance_profile` from iam module to pass rules for SSM
