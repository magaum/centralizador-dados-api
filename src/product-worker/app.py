import os
import json
import boto3
from boto3.dynamodb.types import TypeSerializer

def is_test_event(event):
    return "eventSource" not in event or "aws:sqs" != event["eventSource"]

def handler(event, context):
    print('evento recebido: {}'.format(json.dumps(event)))
    
    produto = json.loads(event["Records"][0]["body"])

    if(is_test_event(event["Records"][0])):
        return "Test event finished"
    
    print("produto recebido {}".format(produto))
    
    serializer = TypeSerializer()
    
    client = boto3.client('dynamodb')
    
    try:
        dynamo_response = client.put_item(
            TableName = os.environ["DYNAMO_TABLE"],
            Item = {
                k: serializer.serialize(v)
                for k, v in produto.items()
            }
        )
        
        print("produto inserido com sucesso {}".format(dynamo_response))
        
    except Exception as e:
        print("erro ao adicionar produto no dynamo {}".format(e))