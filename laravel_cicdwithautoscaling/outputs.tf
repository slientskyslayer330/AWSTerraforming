output "s3_bucket_name" {
  description = "s3 bucket name"
  value       = aws_s3_bucket.laravel_cicd_artifacts.bucket
}

output "s3_bucket_objects" {
  description = "s3 bucket objects"
  value       = [for object in aws_s3_object.laravel_configs : object.key]
}

# output "rds_endpoint" {
#   description = "rds endpoint"
#   value       = aws_db_instance.non_prod_mysql.endpoint
# }

# output "rds_username" {
#   description = "rds username"
#   value       = aws_db_instance.non_prod_mysql.username
# }

# output "rds_password" {
#   description = "rds password"
#   value       = aws_db_instance.non_prod_mysql.password
#   sensitive   = true
# }

# output "redis_endpoint" {
#   description = "redis endpoint"
#   value       = [ for node in aws_elasticache_cluster.non_prod_ec.cache_nodes : node.address ]
# }

output "userdata_rendered" {
  description = "launch template user data"
  value       = data.template_file.userdata.rendered
}

output "alb_endpoint" {
  description = "endpoint dns of alb"
  value       = aws_alb.laravel_alb.dns_name
}

