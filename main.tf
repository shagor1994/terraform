
module "vpc_interface_endpoint" {
  source     = "./module/vpc-interface-endpoint"
  aws_region = var.aws_region
  account_id = var.account_id

}
