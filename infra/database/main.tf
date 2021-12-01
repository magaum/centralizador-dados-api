resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "catalogo-produtos"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "id"
  range_key      = "codigo"

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "codigo"
    type = "S"
  }

  attribute {
    name = "cnpj"
    type = "S"
  }

  attribute {
    name = "categoria"
    type = "S"
  }
  
  attribute {
    name = "nome"
    type = "S"
  }
  
  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  global_secondary_index {
    name               = "CnpjIndex"
    hash_key           = "cnpj"
    range_key          = "id"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["nome", "aplicacaoMinima"]
  }

  global_secondary_index {
    name               = "CodigoIndex"
    hash_key           = "codigo"
    range_key          = "id"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["nome", "aplicacaoMinima"]
  }

  global_secondary_index {
    name               = "CategoriaIndex"
    hash_key           = "categoria"
    range_key          = "id"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["nome", "aplicacaoMinima"]
  }

  global_secondary_index {
    name               = "NomeIndex"
    hash_key           = "nome"
    range_key          = "id"
    write_capacity     = 10
    read_capacity      = 10
    projection_type    = "INCLUDE"
    non_key_attributes = ["nome", "aplicacaoMinima"]
  }

  tags = {
    Name        = "catalogo-produtos"
    Environment = "${var.env}"
  }
}
