terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "machine1" {
  ami                         = "ami-0f924dc71d44d23e2"
  instance_type               = "t2.medium"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-0210f402d17667d5b"]
  availability_zone           = "us-east-2b"
  user_data                   = file("userdata.sh")
  key_name                    = "capstone"

  root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  tags = {
    Name = "jenkins-master"
  }
}
output "jenkins-machine-public-ip" {
  value = aws_instance.machine1.public_ip
}


resource "aws_eip" "lb" {
  instance = aws_instance.machine1.id
  vpc      = true
}


resource "aws_instance" "machine2" {
  ami                         = "ami-0f924dc71d44d23e2"
  instance_type               = "t2.xlarge"
  associate_public_ip_address = true
  vpc_security_group_ids      = ["sg-0210f402d17667d5b"]
  availability_zone           = "us-east-2b"
  user_data                   = file("userdata.sh")
  key_name                    = "capstone"

  root_block_device {
    volume_size           = "30"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }
  tags = {
    Name = "stagging"
  }
}

output "stagging-machine-public-ip" {
  value = aws_instance.machine2.public_ip
}
resource "aws_eip" "lb1" {
  instance = aws_instance.machine2.id
  vpc      = true
}
