const { getSSMValue } = require("../get-ssm-value")
const { mockClient } = require('aws-sdk-client-mock');
const { SSMClient, GetParameterCommand } = require("@aws-sdk/client-ssm");

describe("GetSSMValue Tests", () => {
    it("Should return ssm value", async () => {
        //arrange
        const ssmMockClient = mockClient(SSMClient);
        ssmMockClient.on(GetParameterCommand)
            .resolves({ Parameter: { Value: "some value" } });
        const testValue = "test";
        const expected = "some value";

        //act
        const receivedValue = await getSSMValue(testValue);

        //assert
        expect(receivedValue).toEqual(expected);
    });
})