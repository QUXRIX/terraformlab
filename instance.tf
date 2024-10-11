resource "aws_vpc" "example" {
  cidr_block = "172.17.0.0/16"

  tags = {
    Name = "terraform_vpc1"
  }
}

resource "aws_security_group" "dev_sg" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
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
    Name = "dev-security-group"
  }
}

resource "aws_instance"	"example" {
  ami                       = var.ami_id
  instance_type             = var.instance_type
  vpc_security_group_ids    = [aws_security_group.dev_sg.id]

  user_data                 = <<-EOF
                            #!/bin/bash
                            echo "Hello, world" > index.html
                            nohup busybox httpd -f -p ${var.server_port} &
                            EOF
  
  tags = {
    Name = "terraform-example"
  }
}

output "public_ip" {
  value	= aws_instance.example.public_ip
}