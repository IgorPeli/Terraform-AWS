resource "aws_lb_target_group" "TargetGroup" {
  name        = "EcsTargetGroup"
  port        = 80
  target_type = "ip"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id

  target_health_state {
    enable_unhealthy_connection_termination = false
  }

}