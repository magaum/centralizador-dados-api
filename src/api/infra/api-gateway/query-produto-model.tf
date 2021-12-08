resource "aws_api_gateway_model" "query_produto" {
  rest_api_id  = aws_api_gateway_rest_api.produtos_api.id
  name         = "QueryProduto"
  description  = "Objeto retornado pelas consultas por atributos"
  content_type = "application/json"

  schema = <<EOF
{
    "type": "object",
    "properties": {
        "id": {
            "type": "integer",
            "format": "int64",
            "description": "identificador do produto"
        },
        "nome": {
            "type": "string",
            "description": "nome comercializavel"
        },
        "aplicacaoMinima": {
            "type": "string",
            "description": "valor minimo para aporte"
        }
    }
}
EOF
}