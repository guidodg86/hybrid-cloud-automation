
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
  name = var.ipv4_vrf_name
}
resource "nxos_physical_interface" "r1-spine" {
  interface_id             = var.physical_interface_id
  layer                    = var.physical_interface_layer
}
resource "nxos_ipv4_interface" "r1-spine" {
  vrf          = nxos_ipv4_vrf.example.name
  interface_id = nxos_physical_interface.r1-spine.interface_id
}
resource "nxos_ipv4_interface_address" "r1-spine" {
  vrf          = nxos_ipv4_vrf.example.name
  interface_id = nxos_physical_interface.r1-spine.interface_id
  address      = var.physical_interface_address
  type         = "primary"
}

#BGP peer with R1
resource "nxos_bgp_peer" "r1-peer" {
  asn               = var.bgp_asn
  vrf               = nxos_ipv4_vrf.example.name
  address           = var.bgp_peer_address
  remote_asn        = var.bgp_asn
}
resource "nxos_bgp" "example" {
  admin_state = "enabled"
}
resource "nxos_bgp_instance" "example" {
  admin_state             = nxos_bgp.example.admin_state
  asn                     = nxos_bgp_peer.r1-peer.asn
}
resource "nxos_bgp_address_family" "example" {
  asn                          = nxos_bgp_peer.r1-peer.asn
  vrf                          = nxos_ipv4_vrf.example.name
  address_family               = var.bgp_address_family
}
resource "nxos_bgp_peer_address_family" "example" {
  asn                     = nxos_bgp_peer.r1-peer.asn
  vrf                     = nxos_ipv4_vrf.example.name
  address                 = nxos_bgp_peer.r1-peer.address
  address_family          = nxos_bgp_address_family.example.address_family
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