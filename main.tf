
# module "nat_instance" {
#   source = "./module/nat-instance"
# }

module "dsn_dhcp" {
  source = "./module/custom-dns-server"
}
