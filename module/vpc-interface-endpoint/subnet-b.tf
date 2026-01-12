resource "aws_subnet" "ec2_instance_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.10.1.0/24"
}

resource "aws_security_group" "ec2_instance_sg" {
  name        = "ec2-instance-security-group"
  description = "Security group for EC2 Instance"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.eice_sg.id] # Allow from EICE security group
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-instance-sg"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = "ami-0a33664f59b55fc35" # Amazon Linux 2023 ARM64 AMI 
  instance_type               = "t4g.nano"
  subnet_id                   = aws_subnet.ec2_instance_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_instance_sg.id]
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name = "ec2-instance"
  }

}
