#data "aws_ami" "ami" {
#  most_recent = true
#  name_regex = "devops-practice-with-ansible-my-local-image"
#  owners = ["self"]
#
#}

data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "Centos-8-DevOps-Practice"
  owners           = ["973714476881"]
}

data "aws_route53_zone" "domain" {
  name = var.dns_domain
}

data "aws_caller_identity" "account" {}