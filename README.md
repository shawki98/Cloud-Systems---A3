# Cloud-Systems---A3
The project consists of three modules; VPC, Security groups, and EC2 instance , that deploys a VPC within the AWS us-east-1 region with 4 public subnets

•	The vpc module deploys a complete new VPC with the address space 192.168.0.0/16. Four public subnets must be created from such space. 
•	The module EC2 must create EC2 instances that run a default website on port 80 and two docker NGINX containers on ports 8080 and 8081 respectively. 
•	Each one of the four subnets receive one of the EC2 instances (just as in the picture).
•	The security group module creates a new security group called sg-tf. It allows SSH, HTTP and the two containers ports.
