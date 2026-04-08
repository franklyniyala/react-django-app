# VPC
resource "aws_vpc" "react-django-vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "react-django"
  }
}


# Subnet
resource "aws_subnet" "react-django-subnet" {
  vpc_id     = aws_vpc.react-django-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "react-django-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "react-django-igw" {
  vpc_id = aws_vpc.react-django-vpc.id

  tags = {
    Name = "react-django-igw"
  }
}


# Route Table
resource "aws_route_table" "react-django-rt" {
  vpc_id = aws_vpc.react-django-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.react-django-igw.id
  }

  tags = {
    Name = "react-django-rt"
  }
}

# Route Table Association
resource "aws_route_table_association" "react-django-rt-association" {
  subnet_id      = aws_subnet.react-django-subnet.id
  route_table_id = aws_route_table.react-django-rt.id
}

# Security Groups
resource "aws_security_group" "react-django-sg" {
  name        = "react-django-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.react-django-vpc.id

  tags = {
    Name = "react-django-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.react-django-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.react-django-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}


resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.react-django-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}