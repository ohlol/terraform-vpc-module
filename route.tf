resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
  tags {
    Name = "${var.name}_public"
  }
}

resource "aws_main_route_table_association" "public" {
  route_table_id = "${aws_route_table.public.id}"
  vpc_id = "${aws_vpc.vpc.id}"
}
