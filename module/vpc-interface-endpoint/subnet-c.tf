resource "aws_subnet" "interface_endpoint_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.10.2.0/24"
}


resource "aws_security_group" "interface_endpoint_sg" {
  name        = "interface-endpoint-security-group"
  description = "Security group for VPC Interface Endpoint"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.10.1.0/24"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "interface_endpoint" {
  vpc_id             = aws_vpc.main_vpc.id
  service_name       = "com.amazonaws.ap-south-1.sqs"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.interface_endpoint_subnet.id]
  security_group_ids = [aws_security_group.interface_endpoint_sg.id]

  private_dns_enabled = true

  tags = {
    Name = "vpc-interface-endpoint"
  }
}


