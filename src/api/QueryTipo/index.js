const {
  DynamoDBClient,
  QueryCommand,
} = require("@aws-sdk/client-dynamodb");
const { marshall, unmarshall } = require("@aws-sdk/util-dynamodb");
const { response } = require('/opt/nodejs/response');

const handler = async (event) => {
  console.log(`Event: ${JSON.stringify(event)}`);

  if (!event.queryStringParameters) {
    const error = { mensagem: "Consulta inválida: parâmetro type é obrigatório" }

    console.error(error);

    return response(400, error);
  }

  const { lastEvaluatedKey, type, name } = event.queryStringParameters;

  console.log(`Type: ${type}`);
  console.log(`Name: ${name}`);
  console.log(`LastEvaluatedKey: ${lastEvaluatedKey}`);

  const client = new DynamoDBClient({ region: process.env.REGION });

  let key = 'tipo = :queryValue';
  const expression = { ":queryValue": type };

  if (name) {
    key = key.concat(` and begins_with(nome, :nome)`);
    Object.assign(expression, { ":nome": name });
  }

  console.log("key: ", key);
  console.log("expression: ", expression);

  const input = {
    TableName: process.env.DYNAMO_TABLE,
    IndexName: process.env.DYNAMO_INDEX,
    KeyConditionExpression: key,
    ExpressionAttributeValues: marshall(expression),
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
