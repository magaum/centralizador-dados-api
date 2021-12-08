const { response } = require("../nodejs/response");

describe("Response Tests", () => {
    it("Should return api gateway response", async () => {
        //arrange
        const statusCode = 200;
        const result = { someKey: "other value" };
        const headers = { contentType: "application/test" };

        //act
        const receivedValue = response(statusCode, result, headers, true);

        //assert
        expect(receivedValue.body).not.toBeNull();
    });

    it("Should return api gateway response without headers", async () => {
        //arrange
        const statusCode = 200;
        const result = { someKey: "other value" };

        //act
        const receivedValue = response(statusCode, result);

        //assert
        expect(receivedValue.body).not.toHaveProperty("headers");
    });
})