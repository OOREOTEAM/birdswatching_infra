This module is responsible for creating the DataBase EC2 instance. It creates the following resources:

- Private subnet for database
- Creates route table for database and using dedicated enviroment NAT
- EC2 instance
- Security groups to allow specific trafic `5432` port for web_app and `8301` for consul
- It uses `iam_instance_profile` from iam module to pass rules for SSM
