terraform {
  required_providers {
    nxos = {
      source  = "CiscoDevNet/nxos"
      version = "0.5.5"
    }
  }
}


provider "nxos" {
  username = "admin"
  password = "cisco"
  url      = "https://192.168.201.10"
}
