variable "AWS_ACCES_KEY" {}
variable "AWS_SECRET_ACCESS" {}

provider "aws" {
  region = "eu-west-2"
  access_key = var.AWS_ACCES_KEY
  secret_key = var.AWS_SECRET_ACCESS
}

resource "aws_instance" "nginx" {
  ami           = "aws_ami.id"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_aws_sg.id]

  tags = {
    Name = "Nginx-Load-Balancer"
  }
  # Events   
  #   {   
  #     worker_connections 768;   
  #   } 
  # http {
  #   upstream myproject {
  #   server 127.0.0.1:8000 weight=1;
  #   server 127.0.0.1:8001 weight=1;   
  # }

  # server {
  #   listen 80;
  #   server_name www.domain.com;
  #   location / {
  #     proxy_pass http://myproject;
  #   }
  # }
}

resource "aws_security_group" "nginx_aws_sg" {
  name = "nginx_aws_sg-instance"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "packer-nginx-ws" {
  executable_users = ["self"]
  most_recent      = true
  name_regex       = "^myami-\\d{3}"
  owners           = ["self"]

  filter {
    name   = "name"
    values = ["myami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# resource "aws_instance" "server_A" {
#   ami           = "ami-006a0174c6c25ac06"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.swsel_asg.id]
#   user_data = <<-EOF
#               #!/bin/bash
#               echo "Hello, World!! Server A" > index.html
#               nohup busybox httpd -f -p 8080 &
#               EOF
#   tags = {
#     Name = "server_A"
#   }
  
#   lifecycle {
#     create_before_destroy = true
#   }
# }
# resource "aws_instance" "server_B" {
#   ami           = "ami-006a0174c6c25ac06"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.swsel_asg.id]
#   user_data = <<-EOF
#               #!/bin/bash
#               echo "Hello, World!! Server B" > index.html
#               nohup busybox httpd -f -p 8080 &
#               EOF
#   tags = {
#     Name = "server_B"
#   }
  
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_security_group" "swsel_asg" {
#   name = "swsel-terraform-asg-instance"

#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }



