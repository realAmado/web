/* Two-tier web application stack:
    - ELB
    - 2x EC2 instances
*/

provider "aws" {
  region = "${var.region}"
}

module "vpc" {
  source               = "./vpc"
  name                 = "web"
  cidr                 = "10.0.0.0/16"
  public_subnet        = "10.0.1.0/24"
  enable_dns_hostnames = false
}

resource "aws_instance" "web" {
  ami                         = "${lookup(var.ami, var.region)}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  subnet_id                   = "${module.vpc.public_subnet_id}"
  associate_public_ip_address = true
  user_data                   = "${file("files/web_bootstrap.sh")}"

  vpc_security_groups_ids = [
    "${aws_security_group.web_host_sg.id}",
  ]

  count = 2
}

resource "aws_elb" "web" {
  name            = "web-elb"
  subnets         = ["${module.vpc.public_subnet_id}"]
  security_groups = ["${aws_security_group.web_inbound_sg.id}"]

  listener {
    instance_port = 80
  }
}
