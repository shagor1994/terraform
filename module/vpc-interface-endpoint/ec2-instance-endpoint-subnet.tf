resource "aws_subnet" "ec2_instance_connect_private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.10.0.0/24"
}
# A security group for the EICE (no inbound rules needed for the endpoint itself, 
# but it requires outbound rules to the target instance's SSH port (22)
# and the target instance's security group must allow inbound from the EICE's SG/IPs).

resource "aws_security_group" "eice_sg" {
  name        = "eice-security-group"
  description = "Security group for EC2 Instance Connect Endpoint"
  vpc_id      = aws_vpc.main_vpc.id

  # EICE needs outbound access to the target instance on port 22
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.1.0/24"] # CIDR of the target instance
  }
}

# Create the EC2 Instance Connect Endpoint
resource "aws_ec2_instance_connect_endpoint" "connect_endpoint" {
  subnet_id          = aws_subnet.ec2_instance_connect_private_subnet.id # Subnet where the EICE will be deployed
  security_group_ids = [aws_security_group.eice_sg.id]                   # EICE security group

  # Optional: Enable client IP preservation if needed, subject to certain instance type limitations
  preserve_client_ip = false


}

# Output the DNS name of the EICE

