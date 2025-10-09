This module is responsible for creating the WebApp EC2 instance as autoscaling group. It creates the following resources:

- Private subnet for web_app
- EC2 instances
- The instance count can be set by `var.webapp_count`
- Uses NAT gateway created in load_balancer module
- Creates single route table for web_app and consul
- Security groups to allow specific trafic
- It uses `iam_instance_profile` from iam module to pass rules to use S3 bucket for pictures and SSM
