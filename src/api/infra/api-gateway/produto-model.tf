resource "aws_api_gateway_model" "produto" {
  rest_api_id  = aws_api_gateway_rest_api.produtos_api.id
  name         = "Produto"
  description  = "Objeto retornado pela consulta por id"
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
        "codigo": {
            "type": "string",
            "description": "Codigo interno"
        },
        "aplicacaoMinima": {
            "type": "string",
            "description": "valor minimo para aporte"
            },
        "cnpj": {
            "type": "string",
            "description": "identificador da empresa/fundo/gestor depende do produto"
        },
        "tipo": {
            "type": "string",
            "enum": [
                "renda fixa",
                "renda variavel"
            ],
            "description": "tipo do produto"
        },
        "categoria": {
            "type": "string",
            "enum": [
                "cdb",
                "acoes",
                "lci",
                "lca",
                "cri",
                "cra",
                "fundos"
            ],
            "description": "categoria do produto"
        },
        "status": {
            "type": "string",
            "enum": [
                "disponivel",
                "indisponivel"
            ],
            "description": "status do produto"
        },
        "vencimento": {
            "type": "string",
            "description": "data final em que novos aportes serao permitidos"
        },
        "horaLimiteAplicacao": {
            "type": "string",
            "description": "horario limite para aplicação durante o dia"
        },
        "liquidacao": {
            "type": "string",
            "description": "prazo para liquidacao do resgate"
        }
    }
}
EOF
}