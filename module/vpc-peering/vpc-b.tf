resource "aws_vpc" "vpc_b" {
  cidr_block = "10.1.0.0/16"
  region     = "us_east_1"
  tags = {
    Name = "VPC-B"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = "10.1.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_route_table" "route_table_b" {
  provider = "us_east_1"
  vpc_id   = aws_vpc.vpc_b.id

  # allow traffic from vpc a
  route {
    cidr_block                = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  }

  tags = {
    Name = "route-table-b"
  }
}

resource "aws_route_table_association" "route_table_association_b" {
  route_table_id = aws_route_table.route_table_b.id
  subnet_id      = aws_subnet.private_subnet_b.id
}
resource "aws_instance" "instance_b" {
  provider      = "us_east_1"
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.private_subnet_b.id
  # associate_public_ip_address = true
  key_name               = "shagor"
  vpc_security_group_ids = [aws_security_group.sg_b.id]
  tags = {
    Name = "instance-b"
  }
}

# security group for VPC B
resource "aws_security_group" "sg_b" {
  provider    = "us_east_1"
  description = "Security group for VPC B"
  vpc_id      = aws_vpc.vpc_b.id # Fixed: was vpc_a

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] # Only from VPC A
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16"] # Allow ping from VPC A
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-b"
  }
}
