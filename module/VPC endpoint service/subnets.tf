#vpc-a subnets

resource "aws_subnet" "vpc_a_subnet_1" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = "10.10.0.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "vpc-a-subnet-1"
  }
}

resource "aws_subnet" "vpc_a_subnet_2" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "vpc-a-subnet-2"
  }
}

resource "aws_subnet" "vpc_a_subnet_3" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = "10.10.2.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "vpc-a-subnet-3"
  }
}

resource "aws_subnet" "vpc_a_subnet_4" {
  vpc_id            = aws_vpc.vpc_a.id
  cidr_block        = "10.10.3.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "vpc-a-subnet-4"
  }
}


#vpc-b subnets total 4

resource "aws_subnet" "vpc_b_subnet_1" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = "10.20.0.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "vpc-b-subnet-1"
  }
}

resource "aws_subnet" "vpc_b_subnet_2" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = "10.20.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "vpc-b-subnet-2"
  }
}
resource "aws_subnet" "vpc_b_subnet_3" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = "10.20.2.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "vpc-b-subnet-3"
  }
}

resource "aws_subnet" "vpc_b_subnet_4" {
  vpc_id            = aws_vpc.vpc_b.id
  cidr_block        = "10.20.3.0/24"
  availability_zone = "ap-south-1b"
  tags = {
    Name = "vpc-b-subnet-4"
  }
}
