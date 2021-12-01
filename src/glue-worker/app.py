import os
import json
import boto3
import urllib.parse
import awswrangler as wr

def isTestEvent(message):
    return "s3" not in message

def handler(event, context):
    print('evento recebido: {}'.format(json.dumps(event)))
    
    message = json.loads(event["Records"][0]["body"])["Records"][0]

    if(isTestEvent(message)):
        return "Test event finished"

    bucket = message["s3"]["bucket"]["name"]
    
    key = urllib.parse.unquote(message["s3"]["object"]["key"])
    
    s3_path = "s3://{}/{}".format(bucket, key)

    print('bucket s3_path: {}'.format(s3_path))

    columns = [ "id", "nome", "codigo", "aplicacaoMinima", "cnpj", "tipo", "categoria", "status", "vencimento", "horaLimiteAplicacao", "liquidacao" ]
    
    df = wr.s3.read_parquet(path=s3_path, columns=columns)

    
    wr.dynamodb.put_df(
        df=df,
        table_name=os.environ["DYNAMO_TABLE"]
    )
    
    return "{} registros inseridos".format(len(df)) 