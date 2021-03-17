resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"

  tags = {
    Name = "${var.app_name}_vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}_internet_gateway"
  }
}

resource "aws_subnet" "subnet1_public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet1_public_cidr
  availability_zone       = "us-west-2a"
  tags = {
    Name = "${var.app_name}_subnet1_public"
  }
}

resource "aws_subnet" "subnet2_private" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = "us-west-2b"
  cidr_block              = var.subnet2_private_cidr
  tags = {
    Name = "${var.app_name}_subnet2_private"
  }
}

resource "aws_security_group" "tutorials_vpc_sg" {
  name        = "${var.app_name}_vpc_security_group"
  description = "Ports 80, 443, and 22 are open to the world"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks     = [var.rout_table_cidr]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks     = [var.rout_table_cidr]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks     = [var.rout_table_cidr]
  }

  egress {
  from_port       = 0
  to_port         = 0
  protocol        = "-1"
  cidr_blocks     = [var.rout_table_cidr]
  }

  tags = {
    Name = "${var.app_name}_vpc_security_group"
  }
}

resource "aws_security_group" "tutorials_database_sg" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.subnet1_public_cidr]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks = ["0.0.0.0/24"]
  }
  tags = {
    Name = "${var.app_name}_db_security_group"
  }
}

resource "aws_route_table" "tutorials-rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = var.rout_table_cidr
        gateway_id = aws_internet_gateway.default.id
    }

    tags = {
        Name = "${var.app_name}_rout_table"
    }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet1_public.id
  route_table_id = aws_route_table.tutorials-rt.id
}
