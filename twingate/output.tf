output "active" {
  value = module.rotator.active == "A" ? twingate_service_account_key.A : twingate_service_account_key.B
}

output "A" {
  value = twingate_service_account_key.A
}

output "B" {
  value = twingate_service_account_key.B
}
