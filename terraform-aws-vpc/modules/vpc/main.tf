###################### DATA SOURCE #####################

data "aws_availability_zones" "azs" {
  state = "available"
}

##################### LOCALS ###########################

locals {
  azs                  = data.aws_availability_zones.azs.names
  count                = var.subnet_count == null ? length(local.azs) : var.subnet_count
  rtb_count            = var.create_ngw && var.multi_zone_ngw && var.subnet_count == null ? length(local.azs) : var.create_ngw && var.multi_zone_ngw && var.subnet_count != null ? var.subnet_count : 0
  ngw_rtb_count        = var.create_ngw && var.multi_zone_ngw && var.nat_count == null ? length(local.azs) : var.create_ngw && var.multi_zone_ngw && var.nat_count != null ? var.nat_count : 0
  
}


####################### VPC ###########################

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block                           = var.vpc_cidr_block
  enable_dns_hostnames                 = var.enable_dns_hostnames
  instance_tenancy                     = var.instance_tenancy
  ipv4_ipam_pool_id                    = var.ipv4_ipam_pool_id
  ipv4_netmask_length                  = var.ipv4_netmask_length
  ipv6_cidr_block                      = var.ipv6_cidr_block
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  enable_dns_support                   = var.enable_dns_support
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  assign_generated_ipv6_cidr_block     = var.assign_generated_ipv6_cidr_block

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

################# DEFAULT SECURITY GROUP ###############

resource "aws_default_security_group" "this" {
  count = var.create_vpc ? 1 : 0

  vpc_id = one(aws_vpc.this[*].id)
}

################# INTERNET GATEWAY ######################

resource "aws_internet_gateway" "this" {
  count = var.create_igw ? 1 : 0

  vpc_id = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id

  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

##################### NAT GATEWAY #######################

resource "aws_nat_gateway" "this" {
  count = var.create_ngw && var.multi_zone_ngw == false ? 1 : (var.nat_count != null ? local.ngw_rtb_count : local.rtb_count)

  allocation_id = aws_eip.this[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      Name = var.create_ngw && var.multi_zone_ngw == false ? "${var.name}" : "${var.name}-${local.azs[count.index]}"
    },
    var.tags
  )
}

######################## ELASTIC IP ######################

resource "aws_eip" "this" {
  count = var.create_ngw && var.multi_zone_ngw == false ? 1 : (var.nat_count != null ? local.ngw_rtb_count : local.rtb_count)

  domain = var.eip_domain
  tags = merge(
    {
      Name = var.create_ngw && var.multi_zone_ngw == false ? var.name : "${var.name}-${local.azs[count.index]}"
    },
    var.tags
  )
}

#################### PUBLIC TIER ########################

resource "aws_subnet" "public" {
  count = local.count

  vpc_id                          = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, var.newbits, count.index + 10)
  availability_zone               = local.azs[count.index]
  map_public_ip_on_launch         = var.map_public_ip_on_launch
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
  enable_dns64                    = var.enable_dns64
  ipv6_cidr_block                 = var.assign_ipv6_address_on_creation ? cidrsubnet(var.create_vpc ? aws_vpc.this[0].ipv6_cidr_block : var.ipv6_cidr_block, 8, count.index + 1) : null

  tags = merge(
    {
      Name = "${var.name}-public-${local.azs[count.index]}"
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id

  dynamic "route" {
    for_each = var.create_igw ? [1] : []

    content {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.this[0].id
    }
  }

  dynamic "route" {
    for_each = var.assign_ipv6_address_on_creation ? [1] : []

    content {
      ipv6_cidr_block = "::/0"
      gateway_id      = aws_internet_gateway.this[0].id
    }
  }

  lifecycle {
    ignore_changes = [
      route
    ]
  }

  tags = merge(
    {
      Name = "${var.name}-public"
    },
    var.tags
  )
}

resource "aws_route_table_association" "public" {
  count = var.subnet_count == null ? length(local.azs) : var.subnet_count

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

################## APP TIER #########################

resource "aws_subnet" "app_private" {
  count = local.count

  vpc_id                          = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, var.newbits, count.index + 20)
  availability_zone               = local.azs[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
  enable_dns64                    = var.enable_dns64
  ipv6_cidr_block                 = var.assign_ipv6_address_on_creation ? cidrsubnet(var.create_vpc ? aws_vpc.this[0].ipv6_cidr_block : var.ipv6_cidr_block, 8, count.index + 10) : null

  tags = merge(
    {
      Name = "${var.name}-app-private-${local.azs[count.index]}"
    },
    var.tags
  )
}

resource "aws_route_table" "app_private" {
  count = var.multi_zone_ngw == false ? 1 : (var.nat_count != null ? local.ngw_rtb_count : local.rtb_count)

  vpc_id = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id

  dynamic "route" {
    for_each = var.create_ngw ? [1] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.multi_zone_ngw == false ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
    }
  }

  lifecycle {
    ignore_changes = [
      route
    ]
  }

  tags = merge(
    {
      Name = var.multi_zone_ngw == false ? "${var.name}-app-private" : "${var.name}-app-private-${local.azs[count.index]}"
    },
    var.tags
  )
}


resource "aws_route_table_association" "app_private" {
  count = local.count

  subnet_id      = aws_subnet.app_private[count.index].id
  route_table_id = var.multi_zone_ngw == false ? aws_route_table.app_private[0].id : aws_route_table.app_private[count.index].id
}

##################### DB TIER #######################

resource "aws_subnet" "db_private" {
  count = local.count

  vpc_id                          = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id
  cidr_block                      = cidrsubnet(var.vpc_cidr_block, var.newbits, count.index + 30)
  availability_zone               = local.azs[count.index]
  map_public_ip_on_launch         = false
  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
  enable_dns64                    = var.enable_dns64
  ipv6_cidr_block                 = var.assign_ipv6_address_on_creation ? cidrsubnet(var.create_vpc ? aws_vpc.this[0].ipv6_cidr_block : var.ipv6_cidr_block, 8, count.index + 20) : null

  tags = merge(
    {
      Name = "${var.name}-db-private-${local.azs[count.index]}"
    },
    var.tags
  )
}

resource "aws_route_table" "db_private" {
  count = var.multi_zone_ngw == false ? 1 : (var.nat_count != null ? local.ngw_rtb_count : local.rtb_count)

  vpc_id = var.create_vpc ? aws_vpc.this[0].id : var.vpc_id

  dynamic "route" {
    for_each = var.create_ngw ? [1] : []

    content {
      cidr_block     = "0.0.0.0/0"
      nat_gateway_id = var.multi_zone_ngw == false ? aws_nat_gateway.this[0].id : aws_nat_gateway.this[count.index].id
    }
  }

  lifecycle {
    ignore_changes = [
      route
    ]
  }

  tags = merge(
    {
      Name = var.multi_zone_ngw == false ? "${var.name}-db-private" : "${var.name}-db-private-${local.azs[count.index]}"
    },
    var.tags
  )
}


resource "aws_route_table_association" "db_private" {
  count = local.count

  subnet_id      = aws_subnet.db_private[count.index].id
  route_table_id = var.multi_zone_ngw == false ? aws_route_table.db_private[0].id  : aws_route_table.db_private[count.index].id
 
}



