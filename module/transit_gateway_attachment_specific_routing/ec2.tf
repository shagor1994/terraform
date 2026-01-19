
resource "aws_instance" "ec2_instance_1" {
  ami                         = "ami-0a33664f59b55fc35" # Example AMI ID, replace with a valid one
  instance_type               = "t4g.nano"
  subnet_id                   = aws_subnet.subnet_b.id
  vpc_security_group_ids      = [aws_security_group.ec2_instance_1_sg.id]
  associate_public_ip_address = false

  tags = {
    Name = "ec2-instance-1"
  }
}

resource "aws_instance" "ec2_instance_2" {
  ami                    = "ami-0a33664f59b55fc35" # Example AMI ID, replace with a valid one
  instance_type          = "t4g.nano"
  subnet_id              = aws_subnet.subnet_c.id
  vpc_security_group_ids = [aws_security_group.ec2_instance_2_sg.id]
  key_name = "shagor"

  tags = {
    Name = "ec2-instance-2"
  }

}


resource "aws_instance" "ec2_instance_3" {
  ami                    = "ami-0a33664f59b55fc35" # Example AMI ID, replace with a valid one
  instance_type          = "t4g.nano"
  subnet_id              = aws_subnet.subnet_d.id
  vpc_security_group_ids = [aws_security_group.ec2_instance_3_sg.id]
  key_name = "shagor"

  tags = {
    Name = "ec2-instance-3"
  }

}

resource "aws_security_group" "ec2_instance_1_sg" {
  name        = "ec2_instance_1_sg"
  description = "Security group for EC2 Instance 1"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    #  security_groups = [aws_security_group.eice_sg.id]
    cidr_blocks = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
  }

  # Allow ICMP (ping) from other VPCs
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "ec2-instance-1-sg"
  }
}

resource "aws_security_group" "ec2_instance_2_sg" {
  name        = "ec2_instance_2_sg"
  description = "Security group for EC2 Instance 2"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "10.2.0.0/16"]
  }

  # Allow ICMP (ping) from other VPCs
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-instance-2-sg"
  }
}

resource "aws_security_group" "ec2_instance_3_sg" {
  name        = "ec2_instance_3_sg"
  description = "Security group for EC2 Instance 3"
  vpc_id      = aws_vpc.vpc_c.id



  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16", "10.1.0.0/16"]
  }

  # Allow ICMP (ping) from other VPCs
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ec2-instance-3-sg"
  }
}
