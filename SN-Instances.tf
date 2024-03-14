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
              sudo yum install docker -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo yum install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo docker run -d -p 80:80 nginx
              sudo docker run -d -p 8080:80 nginx
              sudo docker run -d -p 8081:80 nginx
              EOF
  
 tags = {
    Name = "EC2-instance-${count.index + 1}"
  }
}