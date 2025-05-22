resource "aws_security_group" "ALBSG" {
  name        = "ALBSG"
  description = "Permitir entrada na porta 80 para o ALB."
  vpc_id      = aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "SGInbound" {
  security_group_id = aws_security_group.ALBSG.id
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80

}

resource "aws_vpc_security_group_egress_rule" "SGOutbound" {
  security_group_id = aws_security_group.ALBSG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1

}

resource "aws_lb" "LoadBalancer" {
  name               = "LoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ALBSG.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
}

resource "aws_lb_listener" "Listener" {
  load_balancer_arn = aws_lb.LoadBalancer.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TargetGroup.arn
  }

}
