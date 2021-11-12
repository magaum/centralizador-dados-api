# resource "aws_autoscaling_group" "produtos_api" {
#   tag {
#     key                 = "AmazonECSManaged"
#     value               = ""
#     propagate_at_launch = true
#   }
# }

# resource "aws_ecs_capacity_provider" "produtos_api" {
#   name = "produtos-api"

#   auto_scaling_group_provider {
#     auto_scaling_group_arn         = aws_autoscaling_group.produtos_api.arn
#     managed_termination_protection = "ENABLED"

#     managed_scaling {
#       maximum_scaling_step_size = 1000
#       minimum_scaling_step_size = 1
#       status                    = "ENABLED"
#       target_capacity           = 10
#     }
#   }
# }