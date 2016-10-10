resource "terraform_remote_state" "global" {
  backend = "s3"
  config = {
    bucket = "scott"
    key = "terraform/global/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "terraform_remote_state" "region" {
  backend = "s3"
  config = {
    bucket = "scott"
    key = "terraform/region/${var.region}.tfstate"
    region = "us-east-1"
  }
}

resource "aws_vpc" "vpc" {
  cidr_block = "${var.cidr_block}"
  tags {
    Name = "${var.name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public.0.id}"
  depends_on = ["aws_internet_gateway.igw"]
}
