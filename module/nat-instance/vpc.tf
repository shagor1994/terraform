# kill current tf plan
# ps aux | grep terraform | grep -v grep
# kill -9 <PID>

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "tutorial-vpc"
  }
}

# subnet1 and subnet2 in the same vpc

#subnet1 in ap-south-1a
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "tutorial-subnet-1"
  }
}

#subnet2 in ap-south-1b
resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "tutorial-subnet-2"
  }
}

# Internet Gateway for the VPC
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id # Reference the ID of the created VPC

  tags = {
    Name = "vpc-igw"
  }
}


# Get the default route table created with VPC
resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "main-route-table"
  }
}

# provision a nat instance in the subnet1 and output its public ip
resource "aws_instance" "nat_instance" {
  ami                         = "ami-01d349c11390b782f" # Amazon Linux 2 AMI (ap-south-1)
  instance_type               = "t4g.nano"
  subnet_id                   = aws_subnet.subnet1.id
  associate_public_ip_address = true
  source_dest_check           = false
  key_name                    = "shagor" # Add SSH key
  vpc_security_group_ids      = [aws_security_group.nat_sg.id]
  tags = {
    Name = "nat-instance"
  }
}


output "nat_instance_public_ip" {
  value = aws_instance.nat_instance.public_ip
}

# security group for nat instance
resource "aws_security_group" "nat_sg" {
  name   = "nat-sg"
  vpc_id = aws_vpc.main.id

  # Allow SSH from internet (bastion/jump host)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict to your IP in production
  }

  # Allow all traffic from private subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "nat-sg"
  }
}
# provision a private server in subnet2
resource "aws_instance" "server" {
  ami                         = "ami-0d176f79571d18a8f" # Amazon Linux 2 AMI (ap-south-1)
  instance_type               = "t3.nano"
  subnet_id                   = aws_subnet.subnet2.id
  associate_public_ip_address = false # No public IP - truly private
  key_name                    = "shagor"
  vpc_security_group_ids      = [aws_security_group.server_sg.id]
  tags = {
    Name = "private-server"
  }
}
resource "aws_security_group" "server_sg" {
  name   = "server-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Only from within VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "server-sg"
  }
}

output "private_server_private_ip" {
  value = aws_instance.server.private_ip
}

# Create a private route table for subnet2 to route traffic through NAT instance
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id


  # route {
  #   # allow local VPC traffic 
  #   cidr_block = "10.0.0.0/16"
  #   gateway_id = "local"

  # 
  # route all other traffic to the nat instance
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_instance.primary_network_interface_id
  }

  tags = {
    Name = "private-route-table"
  }
}


# Associate subnet2 with private route table (routes through NAT instance)
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.private_route_table.id
}
