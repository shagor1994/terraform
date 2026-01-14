#ec2 instance connect

resource "aws_ec2_instance_connect_endpoint" "connect_endpoint" {
  subnet_id          = aws_subnet.vpc_a_subnet_2.id    # Subnet where the EICE will be deployed
  security_group_ids = [aws_security_group.eice_sg.id] # EICE security group
  # Optional: Enable client IP preservation if needed, subject to certain instance type limitations
  preserve_client_ip = false
}


resource "aws_security_group" "eice_sg" {
  name        = "eice-security-group"
  description = "Security group for EC2 Instance Connect Endpoint"
  vpc_id      = aws_vpc.vpc_a.id

  # EICE needs outbound access to the target instance on port 22
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.1.0/24"] # CIDR of the target instance
  }
}

#interface endpoint

resource "aws_vpc_endpoint" "interface_endpoint" {
  vpc_id             = aws_vpc.vpc_a.id
  service_name       = aws_vpc_endpoint_service.vpc_endpoint_service.service_name
  vpc_endpoint_type  = "Interface"
  subnet_ids         = [aws_subnet.vpc_a_subnet_3.id, aws_subnet.vpc_a_subnet_4.id] # Subnet where the interface endpoint will be created
  security_group_ids = [aws_security_group.interface_endpoint_sg.id]

  # private_dns_enabled = true

  tags = {
    Name = "vpc-a-interface-endpoint"
  }
}

resource "aws_security_group" "interface_endpoint_sg" {
  name        = "interface-endpoint-security-group"
  description = "Security group for VPC Interface Endpoint"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.10.1.0/24"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.10.1.0/24"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#vpc endpoint service
resource "aws_vpc_endpoint_service" "vpc_endpoint_service" {
  acceptance_required = false
  network_load_balancer_arns = [
    aws_lb.nlb.arn
  ]

  tags = {
    Name = "vpc-endpoint-service"
  }
}
