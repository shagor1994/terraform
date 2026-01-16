#associate routes to main route table
resource "aws_route" "route_to_tgw_from_vpc_a" {
  route_table_id         = aws_vpc.vpc_a.default_route_table_id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}


resource "aws_route" "route_to_tgw_from_vpc_b" {
  route_table_id         = aws_vpc.vpc_b.default_route_table_id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "route_to_tgw_from_vpc_c" {
  route_table_id         = aws_vpc.vpc_c.default_route_table_id
  destination_cidr_block = "10.0.0.0/8"
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}


