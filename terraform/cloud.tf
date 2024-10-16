#Some env variables
variable "my_public_ip" {
  type = string
}


# Cloud VPC
resource "aws_vpc" "production" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "Production-cloud-vpc"
  }
}

#One subnet per AZ
resource "aws_subnet" "prod-subnet1" {
  vpc_id               = aws_vpc.production.id
  cidr_block           = "10.10.1.0/24"
  availability_zone_id = "euc1-az1"

  tags = {
    Name = "subnet-Production-1"
  }
}
resource "aws_subnet" "prod-subnet2" {
  vpc_id               = aws_vpc.production.id
  cidr_block           = "10.10.2.0/24"
  availability_zone_id = "euc1-az2"

  tags = {
    Name = "subnet-Production-2"
  }
}
resource "aws_subnet" "prod-subnet3" {
  vpc_id               = aws_vpc.production.id
  cidr_block           = "10.10.3.0/24"
  availability_zone_id = "euc1-az3"

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
  tunnel1_inside_cidr     = "169.254.10.0/30"
  type                    = "ipsec.1"

  tags = {
    Name = "prod-ipsec-tunnel"
  }
}