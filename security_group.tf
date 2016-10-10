resource "aws_security_group" "default" {
  vpc_id = "${aws_vpc.vpc.id}"
  name = "${var.name}_default"
  description = "Default security group"
  tags {
    Name = "${var.name}_default"
  }
}

resource "aws_security_group_rule" "default_allow_all_ingress" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group_rule" "default_allow_all_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.default.id}"
}

resource "aws_security_group" "nat" {
  vpc_id = "${aws_vpc.vpc.id}"
  name = "${var.name}_nat"
  description = "Nat security group"
  tags {
    Name = "${var.name}_nat"
  }
}

resource "aws_security_group_rule" "nat_allow_all_ingress" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["${var.cidr_block}"]
  security_group_id = "${aws_security_group.nat.id}"
}

resource "aws_security_group_rule" "nat_allow_all_egress" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.nat.id}"
}
