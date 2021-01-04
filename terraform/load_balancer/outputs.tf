output "target_group_arn" {
  value = aws_lb_target_group.asg.arn
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.example.dns_name
}
