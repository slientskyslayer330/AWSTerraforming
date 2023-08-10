output "amazon_linux2_ami_id" {
  description = "ami-id of amd64 ubuntu in singapore"
  value       = data.aws_ami.amazon_linux2.id
}

output "instance_ip" {
  description = "public ip of app instance"
  value       = module.app_instance.public_ip
}

output "rds_endpoint" {
  description = "rds endpoint"
  value       = module.db.db_instance_endpoint
}

output "rds_username" {
  description = "rds username"
  value = module.db.db_instance_username
  sensitive = true
}
output "master_password" {
  description = "password of rds master"
  value       = random_password.db.result
  sensitive   = true
}