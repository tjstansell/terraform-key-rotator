module "rotator" {
  source        = "../"
  rotation_days = var.rotation_days
}

resource "google_service_account_key" "A" {
  display_name       = var.name_prefix == null ? "A" : "${var.name_prefix} A"
  service_account_id = var.service_account_id

  keepers = {
    rotate = module.rotator.A.rfc3339
  }
}

resource "google_service_account_key" "B" {
  display_name       = var.name_prefix == null ? "B" : "${var.name_prefix} B"
  service_account_id = var.service_account_id

  triggers = {
    rotate = module.rotator.B.rfc3339
  }
}
