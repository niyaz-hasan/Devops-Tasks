variable "create_vpc" {
  type        = bool
  description = "Whether to create vpc"
  default     = true
}

variable "create_igw" {
  description = "Whether to Internet gateway should be created"
  type        = bool
  default     = true
}


variable "create_ngw" {
  description = "Whether to Nat gateway should be created"
  type        = bool
  default     = true
}

variable "nat_count" {
  type        = number
  description = "How many Nat Gateways needs to create"
  default     = null
}

variable "enable_dns_hostnames" {
  description = "Whether to dns hostnames in vpc should be enabled"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC."
  default     = true
}

variable "enable_network_address_usage_metrics" {
  type        = bool
  description = "Indicates whether Network Address Usage metrics are enabled for your VPC. "
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  type        = bool
  description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC."
  default     = false
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC."
  default     = "default"
}

variable "ipv4_ipam_pool_id" {
  type        = string
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."
  default     = null
}

variable "ipv4_netmask_length" {
  type        = string
  description = "The netmask length of the IPv4 CIDR you want to allocate to this VPC."
  default     = null
}

variable "ipv6_cidr_block" {
  type        = string
  description = "IPv6 CIDR block to request from an IPAM Pool."
  default     = null
}

variable "ipv6_ipam_pool_id" {
  type        = string
  description = " IPAM Pool ID for a IPv6 pool. Conflicts with assign_generated_ipv6_cidr_block."
  default     = null
}

variable "ipv6_netmask_length" {
  type        = string
  description = "Netmask length to request from IPAM Pool. Conflicts with ipv6_cidr_block"
  default     = null
}

variable "ipv6_cidr_block_network_border_group" {
  type        = string
  description = " By default when an IPv6 CIDR is assigned to a VPC a default ipv6_cidr_block_network_border_group will be set to the region of the VPC."
  default     = null
}

variable "multi_zone_ngw" {
  description = "Whether to Nat gateway should be created in all availability zones that are present in the specified region"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name to be used on VPC created"
  type        = string
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Whether to enable Auto assign Public IP for public subnets"
  default     = false
}

variable "assign_ipv6_address_on_creation" {
  type        = bool
  description = "Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. "
  default     = false
}

variable "enable_dns64" {
  type        = bool
  description = "Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations."
  default     = false
}

variable "newbits" {
  type        = number
  description = "This is the number of additional bits with which to extend the prefix. For example, if given a prefix ending in /16 and a newbits value of 4, the resulting subnet address will have length /20"
  default     = 8
}

variable "subnet_count" {
  type        = number
  description = "subnet count for each tier. If nothing specified subnets will be created in all the availability zones that are present in the specified region"
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = null
}

variable "vpc_cidr_block" {
  description = "Cidr range for vpc"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC. Only needed if 'create_vpc' set to 'false'"
  default     = null
}

variable "eip_domain" {
  type        = string
  description = "Indicates if this EIP is for use in VPC"
  default     = "vpc"
}

