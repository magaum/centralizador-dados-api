const { handler } = require("../");
const {
    DynamoDBClient,
    GetItemCommand,
} = require("@aws-sdk/client-dynamodb");
const { mockClient } = require('aws-sdk-client-mock');
jest.doMock('/opt/nodejs/response', () => { }, { virtual: true });

describe("Index tests", () => {
    it("Should return an valid response with a product id", async () => {
        //arrange
        const event = {
            path: "/produtos/1",
        }

        mockClient(DynamoDBClient)
            .on(GetItemCommand)
            .resolves({ Item: { id: { S: "1" } } });

        //act
        const response = await handler(event);

        //assert
        expect(response).toHaveProperty("statusCode", 200);
        expect(response).toHaveProperty("body", JSON.stringify({ id: "1" }));
    })

    it("Should return status code 404 when product dont match any result", async () => {
        //arrange
        const event = {
            path: "/produtos/3",
        }

        mockClient(DynamoDBClient)
            .on(GetItemCommand)
            .resolves({ Item: undefined });

        //act
        const response = await handler(event);

        //assert
        expect(response).toHaveProperty("statusCode", 404);
    })

    it("Should return status code 400 when product id is invalid", async () => {
        //arrange
        const event = {
            path: "/produtos/invalid-id",
        }

        //act
        const response = await handler(event);

        //assert
        expect(response).toHaveProperty("statusCode", 400);
    })
});