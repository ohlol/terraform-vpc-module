resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr_block, 4, count.index)}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  map_public_ip_on_launch = true
  count = "${length(var.availability_zones)}"
  tags {
    Name = "${var.name}_public_${count.index}"
  }
}

resource "aws_subnet" "private" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${cidrsubnet(var.cidr_block, 4, count.index + length(aws_subnet.public.*.id))}"
  availability_zone = "${element(var.availability_zones, count.index)}"
  count = "${length(var.availability_zones) * var.private_subnets_per_az}"
  tags {
    Name = "${var.name}_private_${count.index}"
  }
}
