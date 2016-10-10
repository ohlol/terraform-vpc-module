resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_eip" "vpn" {
  instance = "${module.vpc_instance.id}"
  vpc = true
}
