resource "aws_instance" "web_client" {
  ami                         = "ami-0e75ee289577ab216" # Amazon Linux 2023 ARM64 AMI 
  instance_type               = "t4g.nano"
  subnet_id                   = aws_subnet.vpc_a_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.web_client_sg.id]
  associate_public_ip_address = false
  # iam_instance_profile        = aws_iam_instance_profile.web_profile.name

  tags = {
    Name = "web-client"
  }
}



resource "aws_instance" "web_server_1" {
  ami                         = "ami-0e75ee289577ab216" # Amazon Linux 2023 ARM64 AMI 
  instance_type               = "t4g.nano"
  subnet_id                   = aws_subnet.vpc_b_subnet_2.id
  vpc_security_group_ids      = [aws_security_group.web_server_1_sg.id]
  associate_public_ip_address = false
  #  iam_instance_profile        = aws_iam_instance_profile.web_profile.name

  tags = {
    Name = "web-server-1"
  }

}



resource "aws_instance" "web_server_2" {
  ami                         = "ami-0e75ee289577ab216" # Amazon Linux 2023 ARM64 AMI 
  instance_type               = "t4g.nano"
  subnet_id                   = aws_subnet.vpc_b_subnet_3.id
  vpc_security_group_ids      = [aws_security_group.web_server_2_sg.id]
  associate_public_ip_address = false
  # iam_instance_profile        = aws_iam_instance_profile.web_profile.name

  tags = {
    Name = "web-server-2"
  }

}


resource "aws_security_group" "web_client_sg" {
  name        = "web-client_sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.eice_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
}


resource "aws_security_group" "web_server_1_sg" {
  name        = "web-server-1_sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "web_server_2_sg" {
  name        = "web-server-2_sg"
  description = "Security group for web servers"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    from_port   = 80
    to_port     = 80
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

