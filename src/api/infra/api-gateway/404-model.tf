resource "aws_api_gateway_model" "model_404" {
  rest_api_id  = aws_api_gateway_rest_api.produtos_api.id
  name         = "404"
  description  = "Consultas sem retorno"
  content_type = "application/json"

  schema = <<EOF
{
    "type": "object",
    "properties": {
        "mensagem": {
            "type": "string",
            "description": "Produto não encontrado"
        }
    }
}
EOF
}