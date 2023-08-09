output "ubuntu_ami_id" {
  description = "ami-id of amd64 ubuntu in singapore"
  value       = data.aws_ami.ubuntu.id
}

output "instance_ip" {
  description = "public ip of app instance"
  value       = module.app_instance.public_ip
}

