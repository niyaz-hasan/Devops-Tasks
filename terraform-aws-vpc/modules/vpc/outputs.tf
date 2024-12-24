# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id
}

# INTERNET GATEWAY ID
output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = one(aws_internet_gateway.this[*].id)
}

# NAT GATEWAY ID
output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = var.create_ngw && var.multi_zone_ngw == false ? [aws_nat_gateway.this[0].id] : aws_nat_gateway.this[*].id
}

# ELASTIC IP ADDRESS
output "nat_eip" {
  description = "Elastic IP Address associate with Nat Gateway"
  value       = var.create_ngw && var.multi_zone_ngw == false ? [aws_eip.this[0].id] : aws_eip.this[*].id
}

# SUBNET IDs
output "public_subnet_ids" {
  description = "List of WEB Tier Public Subnet IDs"
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "List of APP Tier Private Subnet IDs"
  value       = aws_subnet.app_private[*].id
}

output "db_subnet_ids" {
  description = "List of DB Tier Private Subnet IDs"
  value       = aws_subnet.db_private[*].id
}



# ROUTE TABLE IDs
output "public_route_table_id" {
  description = "WEB Tier Public Route Table ID"
  value       = aws_route_table.public.id
}

output "app_private_route_table_ids" {
  description = "List of APP tier Private Route Table IDs"
  value       = aws_route_table.app_private[*].id
}

output "db_private_route_table_ids" {
  description = "List of DB tier Private Route Table IDs"
  value       = aws_route_table.db_private[*].id
}



