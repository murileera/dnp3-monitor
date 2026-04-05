terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "dnp3_monitor" {
  name        = "dnp3-monitor-sg"
  description = "Security group for DNP3 Monitor"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
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

resource "aws_key_pair" "dnp3_monitor" {
  key_name   = "dnp3-monitor-key"
  public_key = file("~/.ssh/dnp3-monitor.pub")
}

resource "aws_instance" "dnp3_monitor" {
  ami           = "ami-00de3875b03809ec5"
  instance_type = "t3.micro"

  key_name               = aws_key_pair.dnp3_monitor.key_name
  vpc_security_group_ids = [aws_security_group.dnp3_monitor.id]

  user_data = <<-SCRIPT
    #!/bin/bash
    apt-get update
    apt-get install -y docker.io docker-compose-v2 git
    systemctl start docker
    systemctl enable docker
    cd /home/ubuntu
    git clone https://github.com/murilogantunes/dnp3-monitor.git
    cd dnp3-monitor
    docker compose up -d
  SCRIPT

  tags = {
    Name = "dnp3-monitor"
  }
}

output "public_ip" {
  value       = aws_instance.dnp3_monitor.public_ip
  description = "Public IP address of the DNP3 Monitor server"
}

output "api_url" {
  value       = "http://${aws_instance.dnp3_monitor.public_ip}:8000"
  description = "URL of the DNP3 Monitor API"
}

output "grafana_url" {
  value       = "http://${aws_instance.dnp3_monitor.public_ip}:3000"
  description = "URL of the Grafana dashboard"
}
