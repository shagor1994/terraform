# 3 subnet for 3 vpcs

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.vpc_a.id
  cidr_block = "10.0.0.0/24"

  tags = {
    "name" : "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.vpc_a.id
  cidr_block = "10.0.1.0/24"

  tags = {
    "name" : "subnet-b"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id     = aws_vpc.vpc_b.id
  cidr_block = "10.1.0.0/24"

  tags = {
    "name" : "subnet-c"
  }
}

resource "aws_subnet" "subnet_d" {
  vpc_id     = aws_vpc.vpc_c.id
  cidr_block = "10.2.0.0/24"

  tags = {
    "name" : "subnet-d"
  }
}

