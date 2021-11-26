import boto3
import os
import json

glue_client = boto3.client("glue")

def handler(event, context):
    print("starting glue trigger")

    print("received event: {}".format(json.dumps(event, indent=2)))

    glue_workflow = event['glue_workflow'] if 'glue_workflow' in event else os.getenv('GLUE_WORKFLOW') 

    if glue_workflow is None:
        print('glue workflow not received')

        raise ValueError('glue workflow not received')
    
    print("initializing glue workflow: {}".format(glue_workflow))
    
    response = glue_client.start_workflow_run(Name=glue_workflow)

    print("workflow response: {}".format(json.dumps(response, indent=2)))

    return response