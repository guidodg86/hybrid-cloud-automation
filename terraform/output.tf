output "tunnel1_outside_ip" {
  value = aws_vpn_connection.prod-vpn.tunnel1_address
}

output "tunnel1_key" {
  value = aws_vpn_connection.prod-vpn.tunnel1_preshared_key
  sensitive = true
}

output "tunnel2_outside_ip" {
  value = aws_vpn_connection.prod-vpn.tunnel2_address
}

output "tunnel2_key" {
  value = aws_vpn_connection.prod-vpn.tunnel2_preshared_key
  sensitive = true
}