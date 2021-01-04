output "alb_dns_name" {
  value = "${data.terraform_remote_state.load_balancer.outputs.load_balancer_dns_name}:8080"
  description = "The domain name of the load balancer"
}
