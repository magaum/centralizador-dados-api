const {
  DynamoDBClient,
  GetItemCommand,
} = require("@aws-sdk/client-dynamodb");
const { marshall, unmarshall } = require("@aws-sdk/util-dynamodb");
const { response } = require('/opt/nodejs/response');

const handler = async (event) => {
  console.log(`Event: ${JSON.stringify(event)}`);

  const productId = event.path.split("/").pop();

  if (!Number(productId)) {
    const error = { mensagem: "Consulta inválida: valide o id do produto" }

    console.error(error);

    return response(400, error);
  }

  console.log(`ProductId: ${productId}`);

  const client = new DynamoDBClient({ region: process.env.REGION });

  const input = {
    TableName: process.env.DYNAMO_TABLE,
    Key: marshall({ "id": productId })
  }

  console.log("getting product");

  const command = new GetItemCommand(input);

  const { Item } = await client.send(command);

  console.log("received product ", JSON.stringify(Item));

  if (!Item) {
    const error = { mensagem: "Consulta inválida: produto não existe" }

    console.error(error);

    return response(404, error);
  }


  const produtos = unmarshall(Item);

  const headers = {
    "Content-Type": "application/json"
  };

  return response(200, produtos, headers);
};

module.exports = {
  handler,
};
