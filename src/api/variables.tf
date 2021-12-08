variable "region" {
  type = string
  default = "us-east-1"
}

variable "env" {
  type = string
  default = "dev"
}

variable "dynamo" {
  default = {
    table = "catalogo-produtos"
    categoria_index = "CategoriaIndex"
    cnpj_index = "CnpjIndex"
    tipo_index = "TipoIndex"
    codigo_index = "CodigoIndex"
  }
}