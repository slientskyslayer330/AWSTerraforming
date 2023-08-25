output "instance_ids" {
  description = "id of app instances"
  value       = [for app in aws_instance.apps : app.id]
}

output "alb_attached_instances" {
  description = "id of alb attached instances"
  value       = [for app in aws_alb_target_group_attachment.apps_attachment_to_alb : app.target_id]
}

output "alb_dns" {
  description = "dns of alb"
  value       = aws_alb.test_alb.dns_name
}