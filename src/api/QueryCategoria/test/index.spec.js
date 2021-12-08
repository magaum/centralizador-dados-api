const { handler } = require("../");
const {
    DynamoDBClient,
    QueryCommand,
} = require("@aws-sdk/client-dynamodb");
jest.mock("../get-ssm-value");
const { mockClient } = require('aws-sdk-client-mock');
jest.doMock('/opt/nodejs/response', () => { }, { virtual: true });

describe("Index tests", () => {
    it("Should return status code 200 with valid payload", async () => {
        //arrange
        const event = {
            path: "/produtos/cnpj",
            queryStringParameters: {
                search: "fake cnpj",
                lastEvaluatedKey: "other fake cnpj"
            }
        }
        mockClient(DynamoDBClient)
            .on(QueryCommand)
            .resolves({ Items: [], LastEvaluatedKey: "real cnpj", Count: 0 });

        //act
        const response = await handler(event);

        //assert
        expect(response).toHaveProperty("statusCode", 200)
    })

    it("Should return status code 400 with invalid payload", async () => {
        //arrange
        const event = {}
        const expected = {
            statusCode: 400,
            headers: {},
            body: "{\"mensagem\":\"Consulta inválida: parâmetro search é obrigatório\"}",
            isBase64Encoded: false,
        }
        //act
        const response = await handler(event);

        //assert
        expect(response).toEqual(expected)
    })
});