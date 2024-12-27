data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Cloud VPC
resource "aws_vpc" "production" {
  cidr_block = var.aws_cidr

  tags = {
    Name = "Production-cloud-vpc"
  }
}

#One subnet per AZ
resource "aws_subnet" "prod-subnet1" {
  vpc_id               = aws_vpc.production.id
  cidr_block           = var.aws_cidr_subnet1
  availability_zone_id = var.aws_az1

  tags = {
    Name = "subnet-Production-1"
  }
}
resource "aws_subnet" "prod-subnet2" {
  vpc_id               = aws_vpc.production.id
  cidr_block           = var.aws_cidr_subnet2
  availability_zone_id = var.aws_az2

  tags = {
    Name = "subnet-Production-2"
  }
}
resource "aws_subnet" "prod-subnet3" {
  vpc_id               = aws_vpc.production.id
  cidr_block           = var.aws_cidr_subnet3
  availability_zone_id = var.aws_az3

  tags = {
    Name = "subnet-Production-3"
  }
}

#Main route table for production env
resource "aws_route_table" "prod_route_table" {
  vpc_id           = aws_vpc.production.id
  propagating_vgws = [aws_vpn_gateway.prod-vpn-gw.id]
  tags = {
    Name = "Production-Route-Table"
  }
}

#association of subnets towards main route table
resource "aws_route_table_association" "a_subnet1" {
  subnet_id      = aws_subnet.prod-subnet1.id
  route_table_id = aws_route_table.prod_route_table.id
}
resource "aws_route_table_association" "a_subnet2" {
  subnet_id      = aws_subnet.prod-subnet2.id
  route_table_id = aws_route_table.prod_route_table.id
}
resource "aws_route_table_association" "a_subnet3" {
  subnet_id      = aws_subnet.prod-subnet3.id
  route_table_id = aws_route_table.prod_route_table.id
}

#vpn gateway for advertising the vpc aggregate and receive the routes
resource "aws_vpn_gateway" "prod-vpn-gw" {
  vpc_id          = aws_vpc.production.id
  amazon_side_asn = 65011
  tags = {
    Name = "vpn-gateway"
  }
}

#customer gateway (public info)
resource "aws_customer_gateway" "prod-customer-gateway" {
  bgp_asn    = 65010
  ip_address = var.my_public_ip
  type       = "ipsec.1"

  tags = {
    Name = "main-customer-gateway"
  }
}

#On prem connection data
#From provided cidr looks like amazon is always first available ip and we are the last available IP
#This need to be check on the documentation
resource "aws_vpn_connection" "prod-vpn" {
  customer_gateway_id     = aws_customer_gateway.prod-customer-gateway.id
  vpn_gateway_id          = aws_vpn_gateway.prod-vpn-gw.id
  tunnel1_inside_cidr     = var.tunnel_1_inside_cidr
  tunnel2_inside_cidr    = var.tunnel_2_inside_cidr
  type                    = "ipsec.1"

  tags = {
    Name = "prod-ipsec-tunnel"
  }
}

resource "aws_security_group" "vpn" {
  name        = "Tunnel Security Group"
  description = "Allow inbound traffic from VPN connection"
  vpc_id      = aws_vpc.production.id
  ingress {
    protocol = "-1"
    cidr_blocks = [
      var.tunnel_1_inside_cidr,
      var.tunnel_2_inside_cidr
    ]
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_instance" "web" {
  count = var.create_ec2 == true ? 1 : 0
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.vpn.id]
  subnet_id = aws_subnet.prod-subnet1.id
  tags = {
    Name = "VPN Remote Host"
  }
}