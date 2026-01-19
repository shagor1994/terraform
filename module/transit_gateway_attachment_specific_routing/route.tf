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


resource "aws_ec2_transit_gateway_route_table" "tgw_vpc_a_attachment_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "tgw-vpc-a-attachment-rt"
  }
  
}

resource "aws_ec2_transit_gateway_route_table" "tgw_vpc_b_attachment_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "tgw-vpc-b-attachment-rt"
  } 
}

resource "aws_ec2_transit_gateway_route_table" "tgw_vpc_c_attachment_route_table" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  tags = {
    Name = "tgw-vpc-c-attachment-rt"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_vpc_a_attachment_association" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_a_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_vpc_a_attachment_route_table.id
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_vpc_b_attachment_association" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_b_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_vpc_b_attachment_route_table.id  
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_vpc_c_attachment_association" {
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_c_attachment.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_vpc_c_attachment_route_table.id 
}



#only allow to vpc c from vpc a
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_vpc_a_attachment_propagation" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_vpc_a_attachment_route_table.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_c_attachment.id
}

#only allow to vpc c from vpc b
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_vpc_b_attachment_propagation" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_vpc_b_attachment_route_table.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_c_attachment.id
}

#allow all from vpc c to vpc a and b 
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_vpc_c_attachment_propagation_a" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_vpc_c_attachment_route_table.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_a_attachment.id
} 
resource "aws_ec2_transit_gateway_route_table_propagation" "tgw_vpc_c_attachment_propagation_b" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_vpc_c_attachment_route_table.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_vpc_b_attachment.id
}




