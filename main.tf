locals {
  description = "Private zone for ${var.name}"
  managed_by  = "terraform"
}

resource "aws_route53_zone" "main" {
  name = "${var.name}"

  lifecycle {
    ignore_changes = ["vpc"]
  }

  # you must have a main vpc to indicate that this zone is a private zone
  vpc {
    #vpc_id = "${var.main_vpc}"
  }

  comment       = "${local.description}"
  force_destroy = "${var.force_destroy}"

  tags = {
    "Name"          = "${var.name}"
    "ProductDomain" = "${var.product_domain}"
    "Environment"   = "${var.environment}"
    "Description"   = "${local.description}"
    "ManagedBy"     = "${local.managed_by}"
  }
}

resource "aws_route53_zone_association" "secondary" {
  count   = "${length(var.secondary_vpcs)}"
  zone_id = "${aws_route53_zone.main.zone_id}"
  vpc_id  = "${var.secondary_vpcs[count.index]}"
}
