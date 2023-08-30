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
  name               = var.name_prefix == null ? "A" : "${var.name_prefix} A"
  service_account_id = var.service_account_id
  expire_in_days     = var.rotation_days * 2

  lifecycle {
    replace_triggered_by = [terraform_data.A]
  }
}

resource "twingate_service_account_key" "B" {
  name               = var.name_prefix == null ? "B" : "${var.name_prefix} B"
  service_account_id = var.service_account_id
  expire_in_days     = var.rotation_days * 2

  lifecycle {
    replace_triggered_by = [terraform_data.B]
  }
}
