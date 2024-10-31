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
  url      = "https://192.168.0.101"
}


provider "aws" {
  region = var.aws_region
}