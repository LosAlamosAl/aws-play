// TODO: CommonJS or ES6 module???? Explore.

const {
  DynamoDBClient,
  DescribeTableCommand,
  PutItemCommand
} = require("@aws-sdk/client-dynamodb");

const dynoClient = new DynamoDBClient();

exports.handler = async (event, context) => {
  //console.log(JSON.stringify(event));
  //console.log(JSON.stringify(context));
  //console.log(JSON.stringify(process.env));
  let ret = {
    isBase64Encoded: false,
    statusCode: 200,
    headers: { "Access-Control-Allow-Origin": "*" },
    body: process.env.DB_TABLE_NAME
  };

  const descParams = {
    TableName: process.env.DB_TABLE_NAME
  };

  const descTableCommand = new DescribeTableCommand(descParams);

  try {
    const data = await dynoClient.send(descTableCommand);
    //ret.body = data;
    //return ret;
  } catch (error) {
    console.log(`descTableCommand failed: ${JSON.stringify(error)}`);
    throw new Error(JSON.stringify(error));
  }

  const putParams = {
    TableName: process.env.DB_TABLE_NAME,
    Item: {
      Id: { S: "812676363552" },
      Image: { S: "cracker.png" },
      RekogResults: { S: JSON.stringify(ret) }
    }
  };

  const putItemCommand = new PutItemCommand(putParams);

  try {
    const data = await dynoClient.send(putItemCommand);
    ret.body = data;
    return ret;
  } catch (error) {
    console.log(`descTableCommand failed: ${JSON.stringify(error)}`);
    //throw new Error(error);
  }
};
