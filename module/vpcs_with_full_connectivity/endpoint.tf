#ec2 instance connect endpoint

resource "aws_ec2_instance_connect_endpoint" "eice" {
  subnet_id          = aws_subnet.subnet_a.id
  security_group_ids = [aws_security_group.eice_sg.id]
  tags = {
    Name = "example"
  }
}


resource "aws_security_group" "eice_sg" {
  name        = "eice_sg"
  description = "Security group for EC2 Instance Connect Endpoint"
  vpc_id      = aws_vpc.vpc_a.id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]

  }
}
