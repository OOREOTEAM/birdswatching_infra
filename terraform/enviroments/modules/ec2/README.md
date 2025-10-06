This module is responsible for creating a set of EC2 instances required for the application stack. It creates the following instances:

 - Nginx Load Balancer (in a public subnet)
 - WebApp Server using autoscalin group (in a private subnet)
 - Consul Server (in a private subnet)
 - Database Server (in a private subnet)