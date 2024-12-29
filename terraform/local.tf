resource "local_file" "tofu_output_ansible_hosts" {
  content = <<-DOC
    [routers]
    Tunnel_R1 ansible_host=192.168.0.10 tunnel_outside_address="${aws_vpn_connection.prod-vpn.tunnel1_address}" tunnel_preshared_key="${aws_vpn_connection.prod-vpn.tunnel1_preshared_key}" tunnel_local_address="${aws_vpn_connection.prod-vpn.tunnel1_cgw_inside_address}" tunnel_remote_address="${aws_vpn_connection.prod-vpn.tunnel1_vgw_inside_address}" tunnel_remote_asn="${aws_vpn_gateway.prod-vpn-gw.amazon_side_asn}" tunnel_local_asn="${aws_customer_gateway.prod-customer-gateway.bgp_asn}"
    Tunnel_R2 ansible_host=192.168.0.11 tunnel_outside_address="${aws_vpn_connection.prod-vpn.tunnel2_address}" tunnel_preshared_key="${aws_vpn_connection.prod-vpn.tunnel2_preshared_key}" tunnel_local_address="${aws_vpn_connection.prod-vpn.tunnel2_cgw_inside_address}" tunnel_remote_address="${aws_vpn_connection.prod-vpn.tunnel2_vgw_inside_address}" tunnel_remote_asn="${aws_vpn_gateway.prod-vpn-gw.amazon_side_asn}" tunnel_local_asn="${aws_customer_gateway.prod-customer-gateway.bgp_asn}"

    [routers:vars]
    ansible_user=ansible
    ansible_network_os=ios
    ansible_connection=network_cli
    ansible_become=true
    ansible_become_method=enable

    [nexus]
    L3_Switch ansible_host: ${var.nxos_url}
    nxos_username: ${var.nxos_username}
    DOC
  filename = "../ansible/hosts"
}