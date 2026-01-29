#create aws ec2 instance
resource "aws_instance" "public_server" {
  ami                         = "ami-0e75ee289577ab216" # Amazon Linux 2023 ARM64 AMI 
  instance_type               = "t4g.nano"  
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "shagor" 
  associate_public_ip_address = true 

  security_groups = [ aws_security_group.public_server_sg.id ]

  tags = {
    Name:"app-server"
  }
}


resource "aws_instance" "private_server" {
  ami                         = "ami-0e75ee289577ab216" # Amazon Linux 2023 ARM64 AMI 
  instance_type               = "t4g.nano"  
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = "shagor" 
  security_groups = [ aws_security_group.private_server_sg.id ]
  tags = {
    Name:"db-server"
  }
  
}


resource "aws_instance" "custom_dns_server" {
    ami                         = "ami-0e75ee289577ab216" # Amazon Linux 2023 ARM64 AMI 
    instance_type               = "t4g.nano"  
    subnet_id     = aws_subnet.public_subnet.id
    key_name      = "shagor" 
    associate_public_ip_address = true 
  
    security_groups = [ aws_security_group.public_server_sg.id ]
  
    tags = {
      Name:"custom-dns-server"
    }
  }
  


resource "aws_security_group" "public_server_sg" {
  name        = "public-server-sg"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.custom_dns_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  egress  {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_server_sg" {
    name        = "private-server-sg"
    description = "Allow internal traffic"
    vpc_id      = aws_vpc.custom_dns_vpc.id
    
    # allow internal traffic from public subnet
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = [aws_subnet.public_subnet.cidr_block]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

