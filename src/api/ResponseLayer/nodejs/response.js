const response = (statusCode, body, headers = {}, isBase64Encoded = false) => {
    const gatewayResponse = {
        statusCode,
        headers,
        body: JSON.stringify(body),
        isBase64Encoded
    }

    console.log("response: ", gatewayResponse)

    return gatewayResponse;
}

module.exports = {
    response
}
