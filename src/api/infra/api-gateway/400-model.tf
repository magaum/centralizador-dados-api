resource "aws_api_gateway_model" "model_400" {
  rest_api_id  = aws_api_gateway_rest_api.produtos_api.id
  name         = "400"
  description  = "Consultas inválidas"
  content_type = "application/json"

  schema = <<EOF
{
    "type": "object",
    "properties": {
        "mensagem": {
            "type": "string",
            "description": "Consulta inválida: parâmetro search é obrigatório"
        }
    }
}
EOF
}