terraform {
  required_providers {
    nxos = {
      source  = "CiscoDevNet/nxos"
      version = "0.5.5"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.0"
    }
  }
}


provider "nxos" {
  username = "admin"
  password = "cisco"
  url      = var.nxos_url
}


provider "aws" {
  region = var.aws_region
}