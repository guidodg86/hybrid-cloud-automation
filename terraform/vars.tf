#Some env variables
variable "my_public_ip" {
  type = string
}

# NXOS variables
variable "nxos_username" {
  type = string
  default = "admin"
}

variable "nxos_password" {
  type = string
  default = "cisco"
}

variable "nxos_url" {
  type    = string
  default = "https://192.168.0.101"
}

variable "ipv4_vrf_name" {
    type    = string
    default = "default"
}

variable "physical_interface_id" {
    type    = string
    default = "eth1/2"
}

variable "physical_interface_layer" {
    type    = string
    default = "Layer3"
}

variable "physical_interface_address" {
    type    = string
    default = "172.16.0.1/31"
}

variable "bgp_asn" {
    type    = string
    default = "65010"
}

variable "bgp_peer_address" {
    type    = string
    default = "172.16.0.0"
}

variable "bgp_address_family" {
    type    = string
    default = "ipv4-ucast"
}

# AWS variables
variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "aws_az1" {
  type = string
  default = "use1-az1"
}

variable "aws_az2" {
  type = string
}

variable "aws_az3" {
  type = string
}

variable "aws_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "aws_cidr_subnet1" {
  type    = string
  default = "10.10.0.0/18"
}

variable "aws_cidr_subnet2" {
  type    = string
  default = "10.10.64.0/18"
}

variable "aws_cidr_subnet3" {
  type    = string
  default = "10.10.128.0/18"
}

variable "tunnel_1_inside_cidr" {
  type = string
  default = "169.254.10.0/30"
}

variable "tunnel_2_inside_cidr" {
  type = string
  default = "169.254.247.156/30"
}

variable "create_ec2" {
  type    = bool
  default = false
}