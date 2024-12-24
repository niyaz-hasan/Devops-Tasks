## Requirements

No requirements.



## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_VPC"></a> [VPC](#module\_VPC) | ./modules/vpc | n/a |



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name for the VPC | `string` | test | no |
| <a name="input_region"></a> [region](#input\_region) | Name for the region | `string` | `"us-east-1"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR range for the VPC | `string` | `"10.10.0.0/16"` | no |
| <a name="input_nat_count"></a> [name](#input\_nat) | How many Nat Gateways needs to create | `number` | 3 | no |
| <a name="input_subnet_count"></a> [name](#input\_subnet_count) | subnet count for each tier | `number` | 3 | no |
| <a name="input_multi_zone_ngw"></a> [name](#input\_multi_zone_ngw) | Nat gateway should be created in all availability zones | `bool` | true | no |



## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |

vpc_id
internet_gateway_id
nat_gateway_ids
nat_eip
public_subnet_ids
app_subnet_ids
db_subnet_ids
public_route_table_id
app_private_route_table_ids
db_private_route_table_ids










