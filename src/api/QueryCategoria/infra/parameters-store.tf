resource "aws_ssm_parameter" "categoria" {
  name  = "categoria"
  type  = "String"
  value = "CategoriaIndex"
}

resource "aws_ssm_parameter" "cnpj" {
  name  = "cnpj"
  type  = "String"
  value = "CnpjIndex"
}

resource "aws_ssm_parameter" "codigo" {
  name  = "codigo"
  type  = "String"
  value = "CodigoIndex"
}
