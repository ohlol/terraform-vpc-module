# terraform-vpc-module

This module is used for management of an AWS VPC using Terraform.

## Resources

* Both public (one per AZ) and private subnets (specified as an argument)
* IGW
* NAT gateway w/EIP
* OpenVPN instance w/EIP
* Bastion instance on private subnet
* "default" security group
* "nat" security group

### Security Groups

Any intended filtering should be handled with iptables on the instance itself.

**Default**

_Ingress_ and _Egress_

Allows all traffic from any source.

**NAT**

_Ingress_

Allows all traffic for from the specified VPC `cidr_block`.

_Egress_

Allows all traffic from any source.

## Argument Reference

* `name` - (Required) VPC name.
* `region` - (Required) VPC region.
* `availability_zones` - (Required) Which AZs to use for managed subnets.
* `ami_ebs` - (Required) The EBS-backed AMI to use.
- `ami_hvm-ssd` - (Required) The instance store AMI to use.
* `cidr_block` - (Required) VPC CIDR block.
* `private_subnets_per_az` - (Required) The number of private subnets to create per AZ.

## Attribute Reference

* `vpc_id` - The VPC's ID.
* `public_subnets` - List of public subnets.
* `private_subnets` - List of private subnets.
* `default_security_group_id` - ID of the primary security group for the VPC.
* `nat_security_group_id` - ID of the NAT security group for the VPC.
