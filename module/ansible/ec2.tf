# create vpc and place ec2 instance in a public subnet

resource "aws_vpc" "test_vpc" {
  cidr_block = "10.0.0.0/16"
}

// Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "public-subnet"
  }
}


# Create an internet gateway
resource "aws_internet_gateway" "test_igw" {
  vpc_id = aws_vpc.test_vpc.id
}

# Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.test_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test_igw.id
  }
}


# Associate the public subnet with the route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


# Create an EC2 instance in the public subnet
resource "aws_instance" "test_instance" {
  ami                         = "ami-0d176f79571d18a8f" # Amazon Linux 2 AMI (ap-south-1)
  instance_type               = "t3.nano"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name                    = "shagor"
  vpc_security_group_ids      = [aws_security_group.test_sg.id]
  tags = {
    Name = "private-server"
  }
}

# allow ssh access to the instance
resource "aws_security_group" "test_sg" {
  name   = "test-sg"
  vpc_id = aws_vpc.test_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
