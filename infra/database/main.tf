resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "catalogo-produtos"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "id"

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

  attribute {
    name = "tipo"
    type = "S"
  }

  global_secondary_index {
    name               = "CnpjIndex"
    hash_key           = "cnpj"
    range_key          = "id"
    write_capacity     = 1
    read_capacity      = 1
    projection_type    = "INCLUDE"
    non_key_attributes = ["nome", "aplicacaoMinima"]
  }

  global_secondary_index {
    name               = "CodigoIndex"
    hash_key           = "codigo"
    range_key          = "id"
    write_capacity     = 1
    read_capacity      = 1
    projection_type    = "INCLUDE"
    non_key_attributes = ["nome", "aplicacaoMinima"]
  }

  global_secondary_index {
    name               = "CategoriaIndex"
    hash_key           = "categoria"
    range_key          = "id"
    write_capacity     = 1
    read_capacity      = 1
    projection_type    = "INCLUDE"
    non_key_attributes = ["nome", "aplicacaoMinima"]
  }

  global_secondary_index {
    name               = "TipoIndex"
    hash_key           = "tipo"
    range_key          = "nome"
    write_capacity     = 1
    read_capacity      = 1
    projection_type    = "INCLUDE"
    non_key_attributes = ["aplicacaoMinima"]
  }

  tags = {
    Name        = "catalogo-produtos"
    Environment = "${var.env}"
  }
}
