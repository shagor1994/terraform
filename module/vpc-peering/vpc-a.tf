
resource "aws_vpc" "vpc_a" {
  cidr_block = "10.0.0.0/16"

}

resource "aws_internet_gateway" "igw_a" {
  vpc_id = aws_vpc.vpc_a.id

}

#route table for VPC A
resource "aws_route_table" "route_table_a" {
  vpc_id = aws_vpc.vpc_a.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_a.id
  }

  // allow local VPC traffic
  #   route {
  #     cidr_block = "10.0.0.0/16"
  #     gateway_id = "local"
  #   }
  tags = {
    Name = "route-table-a"
  }
}

# associate route table with VPC A
resource "aws_route_table_association" "route_table_association_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.route_table_a.id
}

# Create a public subnet in VPC A
resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "ap-south-1a"
}


// launch an EC2 instance in VPC A
resource "aws_instance" "instance_a" {
  ami                         = "ami-0d176f79571d18a8f" # Amazon Linux 2 AMI (ap-south-1)
  instance_type               = "t3.nano"
  subnet_id                   = aws_subnet.public_subnet_a.id
  associate_public_ip_address = true
  key_name                    = "shagor"
  vpc_security_group_ids      = [aws_security_group.sg_a.id]
  tags = {
    Name = "instance-a"
  }
}

# security group for VPC A
resource "aws_security_group" "sg_a" {
  description = "Security group for VPC A"
  vpc_id      = aws_vpc.vpc_a.id
  ingress {
    from_port   = 22
    to_port     = 22
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
#output public IP of instance A in console 
output "instance_a_public_ip" {
  value = aws_instance.instance_a.public_ip
}

