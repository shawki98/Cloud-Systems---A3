# Create a new VPC
resource "aws_vpc" "vpc-tf" {
  cidr_block           = "192.168.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "vpc-A" }
}
 
# Create internet gateway
resource "aws_internet_gateway" "igw-tf" {
  vpc_id = aws_vpc.vpc-tf.id
  tags   = { Name = "igw-tf" }
}
 
# Create public subnets
resource "aws_subnet" "public-SN" {
  count                   = 4
  vpc_id                  = aws_vpc.vpc-tf.id
  cidr_block              = "192.168.${count.index + 1}.0/24"
  availability_zone       = "us-east-1${element(["a", "b", "c", "d"], count.index)}"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-SN-${count.index + 1}" }
}
 

# Create public routing table
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.vpc-tf.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-tf.id
  }
  tags = { Name = "Public-RT" }
}
 

#creating EC2 instances 
resource "aws_instance" "public-SN" {
  count = 4

  ami           = "ami-0aae4ed2ead014e0c"
  instance_type = "t2.micro"
  subnet_id     = element(aws_subnet.public-SN.*.id, count.index)
  key_name      = "systS144-key"
  vpc_security_group_ids = [aws_security_group.assign3-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hi from Shawki Shaaban $(hostname)" > /var/www/html/index.html
              EOF

  tags = {
    Name = "EC2-instance-${count.index + 1}"
  }
}
 
#Associate the route table with the subnets
resource "aws_route_table_association" "public-rts" {
  count          = 4
  route_table_id = aws_route_table.public-RT.id
  subnet_id      = element(aws_subnet.public-SN.*.id, count.index)
}
 
resource "aws_security_group" "assign3-sg"{
  name   = "assign3-sg"
  vpc_id = aws_vpc.vpc-tf.id
  tags   = { Name = "igw-tf" }
  
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 8080
    to_port   = 8081
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


 
#Output Vars
output "public-subnet_id1" {
  value = aws_subnet.public-SN[0].id
}

output "public-subnet_id2" {
  value = aws_subnet.public-SN[1].id
}

output "public-subnet_id3" {
  value = aws_subnet.public-SN[2].id
}

output "public-subnet_id4" {
  value = aws_subnet.public-SN[3].id
}
 
 
output "vpc_id" {
  value = aws_vpc.vpc-tf.id
}
