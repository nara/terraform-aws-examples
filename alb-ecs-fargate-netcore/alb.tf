#alb, rule listeners by url, security group to alb.
resource "aws_alb" "test_alb" {
    name = "test-alb-ecs-fargate"
    internal = false
    load_balancer_type = "application"
    subnets = aws_subnet.test_subnets.*.id
    security_groups = [aws_security_group.test_sg_alb.id]
}

resource "aws_alb_target_group" "test_alb_target_group" {
  name        = "test-alb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.test_vpc.id
  target_type = "ip"
}

resource "aws_alb_listener" "test_alb_listener" {
  load_balancer_arn = aws_alb.test_alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.test_alb_target_group.id
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "test_alb_listener_rule_1" {
  listener_arn = aws_alb_listener.test_alb_listener.arn
  priority = 100
  
  action {
    target_group_arn = aws_alb_target_group.test_alb_target_group.id
    type             = "forward"
  }

  condition{
      path_pattern{
          values = ["/site1/*"]
      }
  }
}

resource "aws_alb_listener_rule" "test_alb_listener_rule_2" {
  listener_arn = aws_alb_listener.test_alb_listener.arn
  priority = 200
  
  action {
    target_group_arn = aws_alb_target_group.test_alb_target_group.id
    type             = "forward"
  }

  condition{
      path_pattern{
          values = ["/site2/*"]
      }
  }
}



