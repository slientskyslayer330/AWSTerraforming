output "efs_filesystem_dns_name" {
  description = "DNS name of the created EFS file system"
  value       = aws_efs_file_system.efs_testing.dns_name
}

output "efs_filesystem_id" {
  description = "DNS name of the created EFS file system"
  value       = aws_efs_file_system.efs_testing.id
}


output "amazon_linux_2_ami_id" {
  description = "Ami id of the amazon linux 2 image"
  value       = data.aws_ami.amazon-linux-2.id
}

output "aws_instance_public_ips" {
  value       = aws_instance.application[*].public_ip
  description = "Public Ips of EC2 instances"
}
