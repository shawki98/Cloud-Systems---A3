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
 
 
#Associate the route table with the subnets
resource "aws_route_table_association" "public-rts" {
  count          = 4
  route_table_id = aws_route_table.public-RT.id
  subnet_id      = element(aws_subnet.public-SN.*.id, count.index)
}

 
#Output 
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

output "security_group_id" {
  value = aws_security_group.assign3-sg.id
}
 
output "vpc_id" {
  value = aws_vpc.vpc-tf.id
}
