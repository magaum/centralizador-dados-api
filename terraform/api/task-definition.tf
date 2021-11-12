resource "aws_ecs_task_definition" "produtos_api_task_definition" {
  family                   = "produtos-api"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_produtos_api_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_produtos_api_task_role.arn

  container_definitions = jsonencode([
    {
      name         = "produtos_api"
      image        = "magaum/asp-pdz-ecs"
      network_mode = "awsvpc"
      cpu          = 256
      memory       = 512
      essential    = true
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

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [${join(", ", var.azs)}]"
  # }
}
