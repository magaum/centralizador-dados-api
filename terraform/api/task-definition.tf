
resource "aws_ecs_task_definition" "produtos_api_task_definition" {
  family                   = "produtos-api"
  task_role_arn            = aws_iam_role.ecs_produtos_api_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_produtos_api_task_execution_role.arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  container_definitions = jsonencode([
    {
      name        = "produtos-api"
      image       = "magaum/produtos-api"
      networkMode = "awsvpc"
      cpu         = 1
      memory      = 256
      essential   = true
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

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", var.azs)}]"
  }
}
