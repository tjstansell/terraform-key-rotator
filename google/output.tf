output "active" {
  value = module.rotator.active == "A" ? google_service_account_key.A : google_service_account_key.B
}

output "A" {
  value = google_service_account_key.A
}

output "B" {
  value = google_service_account_key.B
}
