#ec2 instance connect endpoint

resource "aws_ec2_instance_connect_endpoint" "eice" {
  subnet_id          = aws_subnet.subnet_a.id
  security_group_ids = [aws_security_group.eice_sg.id]

  preserve_client_ip = false

  tags = {
    Name = "example"
  }
}


resource "aws_security_group" "eice_sg" {
  name        = "eice_sg"
  description = "Security group for EC2 Instance Connect Endpoint"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # AWS service IPs
  }

  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_instance_1_sg.id]
    description     = "SSH to target EC2 instances"
  }

  # Allow HTTPS outbound for service communication
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS outbound for AWS services"
  }

  tags = {
    Name = "eice-sg"
  }
}



