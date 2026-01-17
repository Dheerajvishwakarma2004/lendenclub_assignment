provider "aws" {
  region = "ap-south-1"
}

resource "aws_security_group" "secure_sg" {
  name        = "secure-sg"
  description = "Secure security group with restricted access"

  ingress {
    description = "Allow SSH only from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.29.137/32"]
  }

  ingress {
    description = "Allow application traffic internally"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description      = "Allow outbound HTTPS to AWS services only"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    prefix_list_ids  = ["pl-63a5400a"] # AWS S3 prefix list (region-safe example)
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"

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
