variable "region" {
  type        = string
  description = "Name for the region"
  default     = "us-east-1"
}

variable "name" {
  type        = string
  description = "Name for the VPC"
  default = "test"
}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR range for the VPC"
  default     = "10.10.0.0/16"
}

variable "nat_count" {
  type        = number
  description = "How many Nat Gateways needs to create"
  default     = 3
}

variable "subnet_count" {
  type        = number
  description = "subnet count for each tier. If nothing specified subnets will be created in all the availability zones that are present in the specified region"
  default     = 3
}

variable "multi_zone_ngw" {
  description = "Whether to Nat gateway should be created in all availability zones that are present in the specified region"
  type        = bool
  default     = true
}