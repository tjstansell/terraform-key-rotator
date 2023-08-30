module "rotator" {
  source        = "../"
  rotation_days = var.rotation_days
}

resource "twingate_service_account_key" "A" {
  name               = var.name_prefix == null ? "A" : "${var.name_prefix} A"
  service_account_id = var.service_account_id
  expire_in_days     = var.rotation_days * 2
  triggers = {
    rotate = module.rotator.A.rfc3339
  }
}

resource "twingate_service_account_key" "B" {
  name               = var.name_prefix == null ? "B" : "${var.name_prefix} B"
  service_account_id = var.service_account_id
  expire_in_days     = var.rotation_days * 2

  triggers = {
    rotate = module.rotator.B.rfc3339
  }
}
