#!/usr/bin/env bash

# Delete all resources deployed using deployall.sh

set -e

# Everything hard coded for demo purposes.
# Use command line arguments for real world application.

# deploy_stack          Stack name for $deploy_cfn file
# deploy_cfn:           The CFN file we create to deploy the layer
# test_stack            Stack name for $test_layer_cfn file
# layer_name            Name of the layer deployed into the account
#                       This can be retrieved in a number of ways:
#                       aws lambda list-layers
#                       [TODO] more!
# layer_version         Will typically be one, but not always
#                       This can be retrieved in a number of ways:
#                       aws lambda list-layers
#                       aws lambda list-layer-versions --layer-name ...

deploy_stack="lambda-layer-stack"
deploy_cfn="deploy_lambda_layer.yml"
test_stack="layer-test-stack"
layer_name="canvas-nodejs"

# Delete the stack (and resources) for the test lambda.
aws cloudformation delete-stack                        \
    --stack-name $test_stack

# Delete the stack (and resources) for the layer itself.
aws cloudformation delete-stack                        \
    --stack-name $deploy_stack

# Get the most recent version of the layer deployed.
# See the blog post for gotchas.
layer_version=$(aws lambda list-layers                  \
    --query 'Layers[?LayerName==`'"${layer_name}"'`].LatestMatchingVersion.Version' \
    --output text)

# The layer deploy stack RETAINs the actual layer, so we
# need to delete it manually--stack delete won't do it.
aws lambda delete-layer-version                        \
    --layer-name $layer_name                           \
    --version-number $layer_version

# Remove the layer's CFN file retrieved via cURL in deployall.sh
rm $deploy_cfn
