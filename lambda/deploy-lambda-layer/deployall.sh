#!/usr/bin/env bash

# Deploy a lambda layer into your account (deploy_stack).
# Use the layer in a test lambda (test_stack)

set -e

# Everything hard coded for demo purposes.
# Use command line arguments for real world application.

# sr_layer_arn:         ARN of the layer in the Serverless App repo
# deploy_cfn:           The CFN file we create to deploy the layer
# test_layer_cfn:       The CFN file to create lambda that tests layer
# deploy_stack          Stack name for $deploy_cfn file
# test_stack            Stack name for $test_layer_cfn file
# my_layer_arn          The ARN of the layer deployed into account
# arn_placeholder       String in the main CFN file to replace with ARN
# layer_name            Name of the layer deployed into the account
# layer_version         Will typically be 1, but not always
# lambda_name:          Symbolic name of test lambda function

sr_layer_arn="arn:aws:serverlessrepo:us-east-1:990551184979:applications/lambda-layer-canvas-nodejs"
deploy_cfn="deploy_lambda_layer.yml"
test_layer_cfn="lambda_with_layer.yml"
layer_name="canvas-nodejs"
deploy_stack="lambda-layer-stack"
test_stack="layer-test-stack"
lambda_name="test-lambda-layer"

# Get the CFN template provided by the Serverless Application
# Repository for the desired lambda layer and put it in a file.
aws serverlessrepo create-cloud-formation-template     \
    --application-id $sr_layer_arn                     \
    --query='TemplateUrl'                              \
    | xargs curl > $deploy_cfn

# Deploy the lambda layer into current account using the
# retrieved CFN template. The deploy command is nice because
# it's a synchronous operation.
aws cloudformation deploy                              \
    --stack-name $deploy_stack                         \
    --template-file $deploy_cfn

# Extract the ARN of the deployed layer.
# Thanks https://alexharv074.github.io/2021/03/15/how-to-write-an-aws-cli-script-part-i-patterns.html
my_layer_arn=$(aws lambda list-layers                  \
    --query 'Layers[?LayerName==`'"${layer_name}"'`].LatestMatchingVersion.LayerVersionArn' \
    --output text)

# Deploy the main CFN file with the test lambda. The
# test lambda uses the deployed layer and will return success
# or failure based on the availability of the layer.
aws cloudformation deploy                              \
    --stack-name $test_stack                           \
    --template-file $test_layer_cfn                    \
    --parameter-overrides LayerARN=${my_layer_arn} LambdaName=${lambda_name} \
    --capabilities CAPABILITY_NAMED_IAM

# Confirm that the layer was correctly deployed by
# executing the test lambda.
aws lambda invoke --function-name ${lambda_name} out.json
cat out.json
rm out.json

# Remove the layer's CFN file retrieved via cURL above
rm $deploy_cfn