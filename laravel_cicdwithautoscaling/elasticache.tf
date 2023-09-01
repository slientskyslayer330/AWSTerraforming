# resource "aws_elasticache_subnet_group" "non-prod_ec_subnet_group" {
#   name       = "non-prod-ec"
#   subnet_ids = [for subnet in aws_subnet.private_subnets : subnet.id]

#   tags = {
#     Name = "non-prod-ec"
#   }
# }

# resource "aws_security_group" "redis" {
#   name   = "non-prod-redis-sg"
#   vpc_id = aws_vpc.non_prod.id

#   ingress {
#     from_port   = 6379
#     to_port     = 6379
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     security_groups = [ aws_security_group.app_sg.id ]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "non-prod-redis-sg"
#   }
# }


# resource "aws_elasticache_cluster" "non_prod_ec" {
#   cluster_id           = "non-prod-elastic-cache"
#   engine               = "redis"
#   node_type            = "cache.t3.micro"
#   num_cache_nodes      = 1
#   az_mode              = "single-az"
#   network_type         = "ipv4"
#   subnet_group_name    = aws_elasticache_subnet_group.non-prod_ec_subnet_group.name
#   parameter_group_name = "default.redis7"
#   engine_version       = "7.0"
#   port                 = 6379
#   security_group_ids   = [aws_security_group.redis.id]
# }
