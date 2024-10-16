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
  url      = "https://192.168.201.10"
}


provider "aws" {
  region = "eu-central-1"
}