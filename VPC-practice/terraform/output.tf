output "igw_id" {
  description = "id of non-prod-igw"
  value       = aws_internet_gateway.nonProdIGW.id
}

output "nat_id" {
  description = "id of non-prod-NAT-gateway"
  value       = aws_nat_gateway.nonProdNAT.allocation_id
}