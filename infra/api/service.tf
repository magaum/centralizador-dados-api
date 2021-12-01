resource "aws_ecs_service" "produtos_api_service" {
  name             = "produtos-api-service"
  cluster          = aws_ecs_cluster.produtos_api_cluster.id
  task_definition  = aws_ecs_task_definition.produtos_api_task_definition.arn
  desired_count    = var.desired_ecs_instances
  platform_version = "1.3.0"
  launch_type      = "FARGATE"

  load_balancer {
    target_group_arn = var.lb_target_group_arn
    container_name   = aws_ecs_task_definition.produtos_api_task_definition.family
    container_port   = 80
  }

  network_configuration {
    security_groups = [aws_security_group.produtos_api_ecs_security_group.id]
    subnets          = var.subnets
    assign_public_ip = true
  }
}
