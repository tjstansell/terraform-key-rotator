locals {
  random_name = try(coalesce(var.key_prefix), null) == null
}

module "rotator" {
  source        = "../"
  rotation_days = var.rotation_days
}

# replace_triggered_by requires resources in this scope only.
resource "terraform_data" "A" {
  input = module.rotator.A.rfc3339
}

resource "terraform_data" "B" {
  input = module.rotator.B.rfc3339
}

resource "twingate_service_account_key" "A" {
  name               = local.random_name ? null : "${var.key_prefix}A"
  service_account_id = var.service_account_id
  expiration_time    = var.rotation_days * 2

  lifecycle {
    replace_triggered_by = [terraform_data.A]
  }
}

resource "twingate_service_account_key" "B" {
  name               = local.random_name ? null : "${var.key_prefix}B"
  service_account_id = var.service_account_id
  expiration_time    = var.rotation_days * 2

  lifecycle {
    replace_triggered_by = [terraform_data.B]
  }
}
