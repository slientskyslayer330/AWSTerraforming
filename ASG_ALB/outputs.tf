output "my_alb_app_ami" {
  value       = data.aws_ami.my_alb_app.id
  description = "My alb app id"
}

output "alb_endpoint" {
  value = aws_alb.my_alb.dns_name
  description = "ALB DNS"
}