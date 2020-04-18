variable "AWS_ACCES_KEY" {}
variable "AWS_SECRET_ACCESS" {}

provider "aws" {
  region = "eu-west-2"
  access_key = var.AWS_ACCES_KEY
  secret_key = var.AWS_SECRET_ACCESS
}

resource "aws_instance" "nginx" {
  ami           = "ami-0cb96ac3c99677647"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx_aws_sg.id]

  tags = {
    Name = "Nginx-Load-Balancer"
  }
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

resource "aws_instance" "swsel_app" {
  ami           = "ami-006a0174c6c25ac06"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.swsel_asg.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World!! ELB Testing" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  tags = {
    Name = "swsel_app"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "swsel_asg" {
  name = "swsel-terraform-asg-instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

