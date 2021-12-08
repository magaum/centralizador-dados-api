const { SSMClient, GetParameterCommand } = require("@aws-sdk/client-ssm");

const getSSMValue = async (parameterName) => {
    const client = new SSMClient({ region: process.env.REGION });

    const command = new GetParameterCommand({ Name: parameterName });

    const { Parameter } = await client.send(command);

    return Parameter.Value;
}

module.exports = { getSSMValue }