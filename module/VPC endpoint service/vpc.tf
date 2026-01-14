resource "aws_vpc" "vpc_a" {
  cidr_block = "10.10.0.0/16"
  tags = {
    Name = "vpc-a"
  }
}

#vpc-b 
resource "aws_vpc" "vpc_b" {
  cidr_block = "10.20.0.0/16"
  tags = {
    Name = "vpc-b"
  }
}
