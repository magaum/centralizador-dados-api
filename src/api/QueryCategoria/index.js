const {
  DynamoDBClient,
  QueryCommand,
} = require("@aws-sdk/client-dynamodb");
const { marshall, unmarshall } = require("@aws-sdk/util-dynamodb");
const { getSSMValue } = require('./get-ssm-value');
const { response } = require('/opt/nodejs/response');

const handler = async (event) => {
  console.log(`Event: ${JSON.stringify(event)}`);

  if (!event.queryStringParameters) {
    const error = { mensagem: "Consulta inválida: parâmetro search é obrigatório" }

    console.error(error);

    return response(400, error);
  }

  const queryAttribute = event.path.split("/").pop();

  const indexName = await getSSMValue(queryAttribute);

  const { lastEvaluatedKey, search } = event.queryStringParameters;

  console.log(`QueryParameter: ${search}`);

  console.log(`QueryAttribute: ${queryAttribute}`);

  const client = new DynamoDBClient({ region: process.env.REGION });

  const input = {
    TableName: process.env.DYNAMO_TABLE,
    IndexName: indexName,
    KeyConditionExpression: `${queryAttribute} = :queryValue`,
    ExpressionAttributeValues: marshall({ ":queryValue": search }),
    Limit: Number(process.env.ITEM_LIMIT)
  }

  if (lastEvaluatedKey)
    input.ExclusiveStartKey = lastEvaluatedKey;

  const command = new QueryCommand(input);

  const { Items, LastEvaluatedKey, Count } = await client.send(command);

  const produtos = Items.map(produto => unmarshall(produto));

  const headers = {
    "Content-Type": "*/*",
    "X-Last-Evaluated-Key": LastEvaluatedKey,
    "X-Total-Count": Count
  };

  return response(200, produtos, headers);
};

module.exports = {
  handler,
};
