#transit gateway
resource "aws_ec2_transit_gateway" "tgw" {
  description = "example transit gateway"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  tags = {
    Name = "example-tgw"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc_a_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_a.id
  subnet_ids         = [aws_subnet.subnet_b.id]

  tags = {
    Name = "tgw-vpc-a-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc_b_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_b.id
  subnet_ids         = [aws_subnet.subnet_c.id]

  tags = {
    Name = "tgw-vpc-b-attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_vpc_c_attachment" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_c.id
  subnet_ids         = [aws_subnet.subnet_d.id]

  tags = {
    Name = "tgw-vpc-c-attachment"
  }
}
