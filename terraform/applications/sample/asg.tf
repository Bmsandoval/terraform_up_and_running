data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.configuration.name
  vpc_zone_identifier = data.aws_subnet_ids.default.ids

  target_group_arns = [data.terraform_remote_state.load_balancer.outputs.sample_target_group_arn]
  health_check_type = "ELB"

  min_size = 1
  max_size = 1

  tag {
    key = "Name"
    value = "${local.application}-asg"
    propagate_at_launch = true
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = data.terraform_remote_state.load_balancer.outputs.sample_http_listener_arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = data.terraform_remote_state.load_balancer.outputs.sample_target_group_arn
  }
}