provider "aws" {
  region  = "us-east-1"
  version = "~>3.2.0"
}

variable "domain_name" {
  default = "a.com"
}

variable "subject_alternative_names" {
  default = []
}

resource "aws_acm_certificate" "cert" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"
}

locals {
  dvo_domain_names = [for dvo in aws_acm_certificate.cert.domain_validation_options: dvo.domain_name]
}

resource "aws_security_group" "sg" {
  for_each = toset(var.subject_alternative_names)
  # Adding this contains protection seems to help get through the plan
  # and onto the apply which then works as expected.
  # name = contains(local.dvo_domain_names, each.key) ? "testing-${each.key}-${index(local.dvo_domain_names, each.key)}" : "THIS_VALUE_WONT_GET_USED"
  name = "testing-${each.key}-${index(local.dvo_domain_names, each.key)}"
}
