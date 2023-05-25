#!/usr/bin/env bash

# Everything hard coded for demo purposes.
# Use command line arguments for real world application.

# sr_layer_arn:         ARN of the layer in the Serverless App repo
# deploy_cfn:           The CFN file we create to deploy the layer
# test_layer_cfn:       The CFN file to create lambda that tests layer
# deploy_stack          Stack name for $deploy_cfn file
# test_stack            Stack name for $test_layer_cfn file
# my_layer_arn          The ARN of the layer deployed into account
# arn_placeholder       String in the main CFN file to replace with ARN

sr_layer_arn="arn:aws:serverlessrepo:us-east-1:990551184979:applications/lambda-layer-canvas-nodejs"
deploy_cfn="deploy_lambda_layer.yml"
test_layer_cfn="lambda_with_layer.yml"
deploy_stack="lambda-layer-stack"
test_stack="layer-test-stack"
arn_placeholder="LAYER_ARN_PLACEHOLDER_REPLACED_BY_SED"

set -x

# Get the CFN template provided by the Serverless Application
# Repository for the desired lambda layer and put it in a file.
#aws serverlessrepo create-cloud-formation-template     \
#    --application-id $sr_layer_arn                     \
#    --query='TemplateUrl'                              \
#    | xargs curl > $deploy_cfn

# Deploy the lambda layer into current account using the
# retrieved CFN template. The deploy command is nice because
# it's a synchronous operation.
#aws cloudformation deploy                              \
#    --stack-name $deploy_stack                         \
#    --template-file $deploy_cfn

# Extract the ARN of the deployed layer.
#my_layer_arn=$(aws cloudformation describe-stacks      \
#    --stack-name $deploy_stack                         \
#    --query 'Stacks[0].Outputs[0].OutputValue'         \
#    --output text)

# Replace the placeholder text in the main CFN file with
# the ARN of the layer deployed into the account.
#sed -i "s/${arn_placeholder}/${my_layer_arn}/" $test_layer_cfn

# Finally, deploy the main CFN file with the test lambda. The
# test lambda uses the deployed layer and will return success
# or failure based on the availability of the layer.
aws cloudformation deploy                              \
    --stack-name $test_stack                           \
    --template-file $test_layer_cfn                    \
    --capabilities CAPABILITY_NAMED_IAM

