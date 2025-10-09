This module is responsible for creating the IAM roles for instance on nginx. It creates the following resources:

- Rule to to attach S3 and SSM policy to web instances
- SSM policy to all instances