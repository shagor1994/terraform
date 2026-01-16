#routes for 3 subnets in 3 vpcs to have full connectivity

# resource "aws_route_table" "route_table_a" {
#   vpc_id = aws_vpc.vpc_a.id

#   // add routes for local connectivity
#   route {
#     cidr_block = aws_vpc.vpc_a.cidr_block
#     gateway_id = "local"
#   }
#   tags = {
#     "Name" : "route-table-a"
#   }
# }

# resource "aws_route_table" "route_table_b" {
#   vpc_id = aws_vpc.vpc_b.id

#   // add routes for local connectivity
#   route {
#     cidr_block = aws_vpc.vpc_b.cidr_block
#     gateway_id = "local"
#   }
#   tags = {
#     "Name" : "route-table-b"
#   }
# }

# resource "aws_route_table" "route_table_c" {
#   vpc_id = aws_vpc.vpc_c.id

#   // add routes for local connectivity
#   route {
#     cidr_block = aws_vpc.vpc_c.cidr_block
#     gateway_id = "local"
#   }
#   tags = {
#     "Name" : "route-table-c"
#   }
# }


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


