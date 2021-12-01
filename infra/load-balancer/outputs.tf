output "lb_target_group_arn" {
  value = aws_lb_target_group.produtos_api.arn
}

output "dns_name" {
  value = aws_lb.produtos_api.dns_name
}