# Terraform template for aws

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.18.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Create the RedHat EC2 instance

# VPC
resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc1"
  }
}


# Internet Gateway
resource "aws_internet_gateway" "gw1" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "gw1"
  }
}


# Create custom route table
resource "aws_route_table" "route1" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw1.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.gw1.id
  }

  tags = {
    Name = "route1"
  }
}


# Create a Subnet
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet1"
  }
}


# Associate subnet with route table
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.route1.id
}


# Create Security Group to allow port 22 (SSH), 8080 (Jenkins), and 8090 (Tomcat)
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc1.id

  ingress {
    description      = "SSH (22)"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Jenkins (8080)"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "Tomcat (8090)"
    from_port        = 8090
    to_port          = 8090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


# Create a network interface with an ip in the subnet
resource "aws_network_interface" "nic1" {
  subnet_id       = aws_subnet.subnet1.id
  private_ips     = ["10.0.1.51"]
  security_groups = [aws_security_group.allow_tls.id]
}


# Create Elastic IP
resource "aws_eip" "eip" {
  vpc                       = true
  network_interface         = aws_network_interface.nic1.id
  associate_with_private_ip = "10.0.1.51"
  depends_on                = [aws_internet_gateway.gw1]
}

# Associate our public SSH key with the EC2 instance
resource "aws_key_pair" "ssh_key" {
  key_name   = "ec2_ssh_key"
  public_key = var.ssh_public_key
}

# Create Linux server and install packages
resource "aws_instance" "rhel-server" {
  ami               = var.ami_id
  instance_type     = "t2.micro"
  availability_zone = "us-east-1a"
  key_name          = aws_key_pair.ssh_key.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.nic1.id
  }
  tags = {
    Name = "rhel-server"
  }

  user_data = file("./setup_script.sh")
}


