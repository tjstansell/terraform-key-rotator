terraform {
  required_version = ">= 1.4.0"

  required_providers {
    twingate = {
      source  = "twingate/twingate"
      version = ">=1.0"
    }
  }
}
