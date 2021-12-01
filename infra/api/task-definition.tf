resource "aws_ecs_task_definition" "produtos_api_task_definition" {
  family                   = "produtos_api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_produtos_api_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_produtos_api_task_role.arn

  container_definitions = jsonencode([
    {
      name         = "produtos_api"
      image        = "magaum/centralizador-api:latest"
      network_mode = "awsvpc"
      cpu          = 1
      memory       = 256
      essential    = true
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group : aws_cloudwatch_log_group.produtos_api_log_group.name,
          awslogs-region : var.region,
          awslogs-stream-prefix : "/aws/ecs"
        }
      }
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      Environment = [
        {
          "Name" : "ASPNETCORE_ENVIRONMENT",
          "Value" : var.env
        },
        {
          "Name" : "REGION",
          "Value" : var.region
        }
      ]
    }
  ])
}
