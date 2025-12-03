resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "private-hosted-zone-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.0.0/24"
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
}
# Private route table with no internet access
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  # No routes - only local VPC traffic allowed (automatic)

  tags = {
    Name = "private-route-table"
  }
}

# Associate private subnet with the private route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "private-hosted-zone-igw"
  }
}


resource "aws_default_route_table" "main_route_table" {
  default_route_table_id = aws_vpc.main_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "default-route-table"
  }
}

resource "aws_security_group" "public_server_sg" {
  name        = "public-server-sg"
  description = "Allow SSH and HTTP traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = {
    Name = "public-server-sg"
  }
}
resource "aws_instance" "public_server" {
  ami                         = "ami-0d176f79571d18a8f" # Amazon Linux 2 AMI (ap-south-1)
  instance_type               = "t3.nano"
  subnet_id                   = aws_subnet.public_subnet.id
  associate_public_ip_address = true
  key_name                    = "shagor"
  vpc_security_group_ids      = [aws_security_group.public_server_sg.id]

  tags = {
    Name = "public-server"
  }

}

output "public_server_public_ip" {
  value = aws_instance.public_server.public_ip
}

resource "aws_security_group" "private_server_sg" {
  name        = "private-server-sg"
  description = "Allow internal traffic"
  vpc_id      = aws_vpc.main_vpc.id

  # allow internal traffic from public subnet
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_subnet.public_subnet.cidr_block]
  }

}

resource "aws_instance" "private_server" {
  ami                         = "ami-0d176f79571d18a8f" # Amazon Linux 2 AMI (ap-south-1)
  instance_type               = "t3.nano"
  subnet_id                   = aws_subnet.private_subnet.id
  associate_public_ip_address = false
  key_name                    = "shagor"
  vpc_security_group_ids      = [aws_security_group.private_server_sg.id]

  tags = {
    Name = "private-server"
  }

}
output "private_server_private_ip" {
  value = aws_instance.private_server.private_ip
}


resource "aws_vpc_dhcp_options" "main_dhcp_options" {
  domain_name         = "shagor.com"
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = {
    Name = "private-hosted-zone-dhcp-options"
  }

}

resource "aws_vpc_dhcp_options_association" "main_dhcp_options_association" {
  vpc_id          = aws_vpc.main_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.main_dhcp_options.id
}




resource "aws_route53_zone" "private_hosted_zone" {
  name = "shagor.com"
  vpc {
    vpc_id = aws_vpc.main_vpc.id
  }

  tags = {
    Name = "private-hosted-zone"
  }
}

#set records in private hosted zone
resource "aws_route53_record" "private_server_record" {
  zone_id = aws_route53_zone.private_hosted_zone.zone_id
  name    = "private-server.shagor.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.private_server.private_ip]
}


