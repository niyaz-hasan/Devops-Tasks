# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.VPC.vpc_id
}

# INTERNET GATEWAY ID
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = module.VPC.internet_gateway_id
}

# NAT GATEWAY ID
output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.VPC.nat_gateway_ids
}

# ELASTIC IP ADDRESS
output "nat_eip" {
  description = "Elastic IP Address associate with Nat Gateway"
  value       = module.VPC.nat_eip
}

# SUBNET IDs
output "public_subnet_ids" {
  description = "List of WEB Tier Public Subnet IDs"
  value       = module.VPC.public_subnet_ids
}

output "app_subnet_ids" {
  description = "List of APP Tier Private Subnet IDs"
  value       = module.VPC.app_subnet_ids
}

output "db_subnet_ids" {
  description = "List of DB Tier Private Subnet IDs"
  value       = module.VPC.db_subnet_ids
}



# ROUTE TABLE IDs
output "public_route_table_id" {
  description = "WEB Tier Public Route Table ID"
  value       = module.VPC.public_route_table_id
}

output "app_private_route_table_ids" {
  description = "List of APP tier Private Route Table IDs"
  value       = module.VPC.app_private_route_table_ids
}

output "db_private_route_table_ids" {
  description = "List of DB tier Private Route Table IDs"
  value       = module.VPC.db_private_route_table_ids
}



