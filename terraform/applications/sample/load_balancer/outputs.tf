output "sample_target_group_arn" {
  value = aws_lb_target_group.asg.arn
}

output "sample_http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "sample_load_balancer_dns_name" {
  value = aws_lb.lb.dns_name
}
