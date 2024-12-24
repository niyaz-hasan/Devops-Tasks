# Virtual Private Cloud
module "VPC" {

  source = "./modules/vpc"

  name           = var.name
  vpc_cidr_block = var.vpc_cidr_block
  nat_count      = var.nat_count
  subnet_count   = var.subnet_count
  multi_zone_ngw = var.multi_zone_ngw
}
