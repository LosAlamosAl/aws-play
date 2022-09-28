// TODO: CommonJS or ES6 module???? Explore.
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
  return ret;
};
