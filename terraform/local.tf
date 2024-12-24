resource "local_file" "tf_ansible_vars_file_new" {
  content = <<-DOC
    router_1_ip: ${var.router_1_ip}
    tunnel_1_outside_address: ${aws_vpn_connection.prod-vpn.tunnel1_address}
    tunnel_1_preshared_key: ${aws_vpn_connection.prod-vpn.tunnel1_preshared_key}
    tunnel_1_local_address: ${aws_vpn_connection.prod-vpn.tunnel1_cgw_inside_address}
    tunnel_1_remote_address: ${aws_vpn_connection.prod-vpn.tunnel1_vgw_inside_address}
    tunnel_1_remote_asn: ${aws_vpn_gateway.prod-vpn-gw.amazon_side_asn}
    tunnel_1_local_asn: ${aws_customer_gateway.prod-customer-gateway.bgp_asn}

    nxos_url: ${var.nxos_url}
    nxos_username: ${var.nxos_username}
    DOC
  filename = "../ansible/tf_ansible_vars_file.yml"
}