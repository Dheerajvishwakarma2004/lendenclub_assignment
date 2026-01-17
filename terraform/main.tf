provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "secure_sg" {
  name        = "secure-sg"
  description = "Secure security group with restricted access"

  ingress {
    description = "Allow SSH for setup"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow public HTTP access to application"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t3.micro"
  key_name      = "devsecops-key"

  vpc_security_group_ids = [aws_security_group.secure_sg.id]

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "devsecops-secure-instance"
  }
}
