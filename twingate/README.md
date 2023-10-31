# Twingate service account key rotation

This module provides a simple mechanism to manage two keys for a Twingate
service account, rotating them on a schedule.  If you have a CI system
that re-deploys your infrastructure regularly to keep manual drift from
happening, this can be used to automatically rotate keys.

As an example

```hcl
resource "twingate_service_account" "github" {
  name = "GitHub Actions"
}

module "key_rotator" {
  source = "git::https://github.com/23andme-private/terraform-key-rotator.git//twingate?ref=main"

  service_account_id = twingate_service_account.github.id
  key_prefix         = null  # use random names
  rotation_days      = 6     # rotate after 6 days
}
```

Then publish `module.key_rotator.active.token` somewhere...
