output "alb_dns_name" {
  value = data.terraform_remote_state.load_balancer.outputs.sample_load_balancer_dns_name
  description = "The domain name of the load balancer"
}
