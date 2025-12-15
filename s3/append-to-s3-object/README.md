# Welcome to your CDK JavaScript project

This is a blank project for CDK development with JavaScript.

The `cdk.json` file tells the CDK Toolkit how to execute your app. The build step is not required when using JavaScript.

## Install from fresh clone

```sh
npm install
cdk bootstrap
cdk deploy
aws s3 cp someobjectname s3://bucket-name-output-by-cdk-deploy
curl -X PUT https://api-url-output-by-cdk-deploy/put
aws s3 cp s3://bucket-name-output-by-cdk-deploy/someobjectname .
# Check for "//Appended text" at bottom of someobjectname
cdk destroy
# Manually delete CDKToolkit stack in console or via aws cli
# Manually delete logs in console or via aws cli
```

## Useful commands

- `npm run test` perform the jest unit tests
- `npx cdk deploy` deploy this stack to your default AWS account/region
- `npx cdk diff` compare deployed stack with current state
- `npx cdk synth` emits the synthesized CloudFormation template
