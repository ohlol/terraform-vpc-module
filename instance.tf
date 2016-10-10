module "bastion_instance" {
  source = "vendor/modules/terraform-bootstrapped_instance-module"

  name = "bastion"
  region = "${var.region}"
  ami = "${var.ami_hvm-ssd}"
  availability_zone = "${element(var.availability_zones, 0)}"
  iam_instance_profile = "${terraform_remote_state.global.output.ec2_readonly_role}"
  instance_type = "t2.small"
  key_name = "builder"
  security_groups = "${aws_security_group.default.id}"
  subnet_id = "${aws_subnet.private.0.id}"
  count = 1
  role = "bastion"
  env = "${var.name}"
  provisioner = "chef"
}

module "vpc_instance" {
  source = "vendor/modules/terraform-bootstrapped_instance-module"

  name = "vpn"
  region = "${var.region}"
  ami = "${var.ami_hvm-ssd}"
  availability_zone = "${element(var.availability_zones, 0)}"
  iam_instance_profile = "${terraform_remote_state.global.output.ec2_readonly_role}"
  instance_type = "t2.small"
  key_name = "builder"
  security_groups = "${aws_security_group.default.id}"
  source_dest_check = false
  subnet_id = "${aws_subnet.public.0.id}"
  count = 1
  role = "vpn"
  env = "${var.name}"
  provisioner = "chef"
}

resource "aws_route53_record" "vpn" {
  zone_id = "${terraform_remote_state.region.output.route53_zone_id}"
  name = "vpn.${var.name}.${terraform_remote_state.region.output.dns_domain}"
  type = "A"
  ttl = "300"
  records = ["${aws_eip.vpn.public_ip}"]
}
