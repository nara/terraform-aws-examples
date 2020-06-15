resource "aws_ecs_cluster" "test_ecs_fargate_cluster" {
  name = "test-ecs-fargate-cluster"
}

resource "aws_ecs_task_definition" "test_ecs_task_def" {
  family = "web"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu = var.fargate_cpu
  memory = var.fargate_memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = data.template_file.task_definition.rendered
}

resource "aws_ecs_service" "test_ecs_service"{
  name = "test-ecs-netcore-service"
  cluster = aws_ecs_cluster.test_ecs_fargate_cluster.id
  task_definition = aws_ecs_task_definition.test_ecs_task_def.arn
  desired_count = 2
  launch_type = "FARGATE"
  
  load_balancer {
    target_group_arn = aws_alb_target_group.test_alb_target_group.arn
    container_name   = "dotnetappsample"
    container_port   = 80
  }

  network_configuration {
    subnets = aws_subnet.test_subnets.*.id
    security_groups = [aws_security_group.test_sg_ecs_tasks.id]
    assign_public_ip = true
  }

  depends_on = [
    aws_iam_role_policy.test_ecs_service_role_policy,
    aws_alb_listener_rule.test_alb_listener_rule_1,
    aws_alb_listener_rule.test_alb_listener_rule_2
  ]
}


resource "aws_cloudwatch_log_group" "test_cw_ecs" {
  name = "test-ecs-group/ecs-agent"
}

resource "aws_cloudwatch_log_group" "test_cw_container" {
  name = "test-ecs-group/app-netcore"
}