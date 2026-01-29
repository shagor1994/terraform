resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.custom_dns_vpc.id
  tags = {
    Name = "private-hosted-zone-igw"
  }
}


resource "aws_default_route_table" "main_route_table" {
  default_route_table_id = aws_vpc.custom_dns_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "default-route-table"
  }
}