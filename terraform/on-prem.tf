
#Hostname -> not needed just for testing
resource "nxos_system" "example" {
  name = "N9K-Spine"
}

resource "nxos_feature_bgp" "example" {
  admin_state = "enabled"
}
resource "nxos_feature_interface_vlan" "example" {
  admin_state = "enabled"
}

#interface towards CSR1000 - R1
resource "nxos_ipv4_vrf" "example" {
  name = "default"
}
resource "nxos_physical_interface" "r1-spine" {
  interface_id             = "eth1/2"
  layer                    = "Layer3"
}
resource "nxos_ipv4_interface" "r1-spine" {
  vrf          = "default"
  interface_id = "eth1/2"
}
resource "nxos_ipv4_interface_address" "r1-spine" {
  vrf          = "default"
  interface_id = "eth1/2"
  address      = "172.16.0.1/31"
  type         = "primary"
}

#BGP peer with R1
resource "nxos_bgp_peer" "r1-peer" {
  asn               = "65010"
  vrf               = "default"
  address           = "172.16.0.0"
  remote_asn        = "65010"
}
resource "nxos_bgp" "example" {
  admin_state = "enabled"
}
resource "nxos_bgp_instance" "example" {
  admin_state             = "enabled"
  asn                     = "65010"
}
resource "nxos_bgp_address_family" "example" {
  asn                          = "65010"
  vrf                          = "default"
  address_family               = "ipv4-ucast"
}
resource "nxos_bgp_peer_address_family" "example" {
  asn                     = "65010"
  vrf                     = "default"
  address                 = "172.16.0.0"
  address_family          = "ipv4-ucast"
}

#NO WAY TO CREATE VLAN VIA TERRAFORM
#NEED TO CREATE VLAN MANUALLY
resource "nxos_svi_interface" "vlan10" {
  interface_id = "vlan10"
  admin_state  = "up"
}
resource "nxos_svi_interface" "vlan20" {
  interface_id = "vlan20"
  admin_state  = "up"
}
#This one does not work!! How can I put ip addr to the svi????
# ALSO how can I advertise the prefix via BGP???
# resource "nxos_ipv4_interface_address" "vlan10" {
#   vrf          = "default"
#   interface_id = "vlan10"
#   address      = "10.25.0.1/24"
#   type         = "primary"
# }