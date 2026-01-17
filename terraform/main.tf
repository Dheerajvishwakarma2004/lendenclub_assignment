provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "vulnerable_sg" {
  name        = "vulnerable-sg"
  description = "Intentionally vulnerable security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0f5ee92e2d63afc18" # Amazon Linux 2 (ap-south-1)
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.vulnerable_sg.id]

  tags = {
    Name = "devsecops-vulnerable-instance"
  }
}
