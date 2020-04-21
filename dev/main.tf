variable "AWS_ACCES_KEY" {}
variable "AWS_SECRET_ACCESS" {}
variable "NGINX_AMI" {}
  


provider "aws" {
  region = "eu-west-2"
  access_key = var.AWS_ACCES_KEY
  secret_key = var.AWS_SECRET_ACCESS
  nginx_image_id = var.NGINX_AMI
}

resource "aws_security_group" "nginx_aws_sg" {
  name = "nginx_aws_sg-instance"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "nginx_aws_sg-instance"
  }
}

resource "aws_instance" "nginx" {
  ami           = nginx_image_id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_aws_sg.id]

  tags = {
    Name = "Nginx-Load-Balancer"
  } 
}
