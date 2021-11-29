data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-produto"
  cidr = var.cidr

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  public_subnets  = [cidrsubnet(var.cidr, 4, 0), cidrsubnet(var.cidr, 4, 1)]
  private_subnets = [cidrsubnet(var.cidr, 4, 2), cidrsubnet(var.cidr, 4, 3), cidrsubnet(var.cidr, 4, 4)]

  enable_nat_gateway = false
  create_igw         = false

  tags = {
    Environment = var.env
  }
}
