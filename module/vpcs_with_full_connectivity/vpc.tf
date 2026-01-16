# 3 vpc

resource "aws_vpc" "vpc_a" {
  cidr_block = "10.0.0.0/16"

  tags = {
    "name" : "vpc-a"
  }

}

resource "aws_vpc" "vpc_b" {
  cidr_block = "10.1.0.0/16"

  tags = {
    "name" : "vpc-b"
  }

}


resource "aws_vpc" "vpc_c" {
  cidr_block = "10.2.0.0/16"

  tags = {
    "name" : "vpc-c"
  }
}
