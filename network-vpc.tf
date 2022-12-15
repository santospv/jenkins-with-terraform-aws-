resource "aws_vpc" "vpc" {
    enable_dns_hostnames = true
    enable_dns_support   = true
    cidr_block = "192.168.0.0/22"
    tags = {
        Name   = "vpc-terraform"
    }
}
resource "aws_subnet" "public_subnet" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "192.168.0.0/24"
    tags = {
      "Name"   = "public-subnet-terraform"
    }
  }
resource "aws_subnet" "private_subnet" {
    vpc_id     = aws_vpc.vpc.id
    cidr_block = "192.168.1.0/24"
    tags = {
      "Name"   = "private-subnet-terraform"
    }
}
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.vpc.id
    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.public_internet_gateway.id
    }
    tags   = {
      "Name" = "public-route-table-terraform"
    }
}
resource "aws_route_table" "private_route_table" {
    vpc_id = aws_vpc.vpc.id
    tags   = {
      "Name" = "private-route-table-terraform"
    }
}
resource "aws_route_table_association" "public_rta" {
    subnet_id       = aws_subnet.public_subnet.id
    route_table_id  = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "private_rta" {
    subnet_id       = aws_subnet.private_subnet.id
    route_table_id  = aws_route_table.private_route_table.id
}
resource "aws_internet_gateway" "public_internet_gateway" {
    vpc_id = aws_vpc.vpc.id
    tags   = {
        Name = "public-internet-gateway-terraform"
    }  
}
resource "aws_security_group" "security_group" {
    name = "security-group-terraform"
    vpc_id = aws_vpc.vpc.id
    ingress {
      description   = "ssh access"
      cidr_blocks   = [ "0.0.0.0/0" ]
      from_port     = 22
      to_port       = 22
      protocol      = "tcp"    
    }
    ingress {
      description   = "http proxy acess"
      cidr_blocks   = [ "0.0.0.0/0" ]
      from_port     = 8080
      to_port       = 8080
      protocol      = "tcp"    
    }
    ingress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks      = ["0.0.0.0/0"] 
    }
    egress {
      cidr_blocks   = [ "0.0.0.0/0" ]
      from_port     = 22
      to_port       = 22
      protocol      = "tcp"
    } 
    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks      = ["0.0.0.0/0"] 
    }
    tags   = {
      Name = "My Lab Security Whith Terraform"
  }
}