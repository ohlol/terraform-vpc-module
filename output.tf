output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "private_subnets" {
  value = "${join(",", aws_subnet.private.*.id)}"
}

output "public_subnets" {
  value = "${join(",", aws_subnet.public.*.id)}"
}

output "default_security_group_id" {
  value = "${aws_security_group.default.id}"
}

output "nat_security_group_id" {
  value = "${aws_security_group.nat.id}"
}
