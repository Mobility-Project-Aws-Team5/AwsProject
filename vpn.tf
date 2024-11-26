# resource "aws_vpn_gateway" "vpn_gateway" {
#   vpc_id = aws_vpc.main.id
#   amazon_side_asn = 64512
# }

# resource "aws_customer_gateway" "customer_gateway" {
#   ip_address = "1.229.54.140"
#   bgp_asn = 65000
#   type = "ipsec.1"
# }

# resource "aws_vpn_connection" "vpn_connection" {
#   vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
#   customer_gateway_id = aws_customer_gateway.customer_gateway.id
#   type = "ipsec.1"
#   static_routes_only = true

#   tunnel1 {
#     pre_shared_key = "testtest"
#   }

#   tunnel2 {
#     pre_shared_key = "testtest"
#   }
  
#   static_routes {
#     destination_cidr_block = "192.168.2.0/24"
#   }
# }

# resource "aws_route" "route_to_customer" {
#   route_table_id = aws_vpc.main.main_route_table_id
#   destination_cidr_block = "192.168.2.0/24"
#   vpn_gateway_id = aws_vpn_gateway.vpn_gateway.id
# }