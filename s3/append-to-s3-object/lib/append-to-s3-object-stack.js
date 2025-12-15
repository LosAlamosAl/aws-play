const path = require("node:path");
const { Stack, RemovalPolicy, CfnOutput } = require("aws-cdk-lib");
const lambda = require("aws-cdk-lib/aws-lambda");
const apigateway = require("aws-cdk-lib/aws-apigateway");
const s3 = require("aws-cdk-lib/aws-s3");

const bucketName = "append-to-s3-object";
const objectName = "someobjectname";

class AppendToS3ObjectStack extends Stack {
  constructor(scope, id, props) {
    super(scope, id, props);

    const bucket = new s3.Bucket(this, bucketName, {
      versioned: true,
      removalPolicy: RemovalPolicy.DESTROY,
      autoDeleteObjects: true
    });

    const putFunction = new lambda.Function(this, "PutFunction", {
      runtime: lambda.Runtime.NODEJS_LATEST,
      code: lambda.Code.fromAsset("lambda"),
      handler: "put.handler",
      environment: {
        BUCKET_NAME: bucket.bucketName,
        OBJECT_NAME: objectName
      }
    });

    bucket.grantReadWrite(putFunction);

    const api = new apigateway.LambdaRestApi(this, "AppendToS3ObjectApi", {
      handler: putFunction,
      proxy: false
    });

    const putResource = api.root.addResource("put");
    putResource.addMethod("PUT");

    new CfnOutput(this, "BucketName", {
      value: bucket.bucketName,
      description: "S3 Bucket name"
    });
  }
}

module.exports = { AppendToS3ObjectStack };
