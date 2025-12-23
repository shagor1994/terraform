
module "vpc_peering" {
  source = "./module/vpc-peering"
  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }
}
