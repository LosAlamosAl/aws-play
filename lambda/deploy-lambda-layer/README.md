## AWS Play: Deploy Lambda Layer with CLI and CFN

This repo contains two shell scripts (`deployall.sh` and `deleteall.sh`) that test the process of automatically installing a lambda layer from the [Serverless Repository](https://aws.amazon.com/serverless/serverlessrepo/). The scripts also test that the installation of the layer was successful. In this repo we work specifically with the [`lambda-layer-canvas-nodejs`](https://serverlessrepo.aws.amazon.com/applications/us-east-1/990551184979/lambda-layer-canvas-nodejs) but the code should work with any layer in the Serverless Repository.

> Please see my [blog post]() on this topic for a full explanation of the process and commands used in the scripts.

### Requirements

- [AWS CLI Version 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- `curl`, `bash`
- Appropriate credential to deploy to target AWS account (unfortunately `admin` because an IAM policy is created)

### Running the Scripts

First run `deployall.sh` to install and test the layer, and then `deleteall.sh` to remove all the resources that have been installed in our account. The scripts themselves are commented and the following sections describe the actions of each script.

#### `deployall.sh`

The `deployall.sh` script works as follows:

1. Retrieve a Cloudformation template from the Serverless Repository that will deploy the lambda layer into our account. Store the template in a temporary file.
1. Run Cloudformation on the template to create a stack (`lambda-layer-stack`) with a resource for the lambda layer. The layer is now deployed to our account.
1. Use the AWS CLI to extract the ARN of the layer that was just deployed into our account.
1. Use Cloudformation to deploy another stack, `layer-test-stack`, which will test that the layer was installed into our account successfully. The YAML file `lambda_with_layer.yml` is the source for this stack. The ARN of the layer to test is passed as a parameter to the Cloudformation run.
1. Conform that the layer was correctly installed by invoking the test lambda. The output from this lambda function is displayed in the terminal.
1. Finally, delete the temporary template retrieved in Step 1.

Before running `deleteall.sh` you can explore the resources created in your account by playing with some of these AWS CLI commands:

```sh
aws cloudformation describe-stacks ...
aws lambda list-layers ...
aws lambda invoke ...
aws lambda list-layer-versions ...
```

#### `deleteall.sh`

The `deleteall.sh` script the previously installed resources from our account.In detail:

1. Use Cloudformation to delete the `lambda-layer-stack`.
1. Use Cloudformation to delete the `layer-test-stack`.
1. The layer itself is not deleted by Cloudformation since, by default, its `RetentionPolicy` is `RETAIN`.
1. Get the **latest version** of the layer and manually delete it using the AWS CLI. PLease see the [blog post](for potential gotchas with lambda layer versions).

### Disclaimer

These scripts install few resources (a lambda layer, a test lambda function, and lambda logs) and we only execute the test lambda once (or a few times if you play around with it) so runaway AWS bills should be unlikely. However, with all things AWS, there is potential for billing surprises and I make to promise that there won't be any with this code. **Use at your own risk**.

Get ARN of lambda layer from the [AWS Serverless Repository](https://serverlessrepo.aws.amazon.com/applications). There appears to be no way to query the repo symbolically. You must search for the layer on the site and copy it's ARN manually (it's shopwn in tiny text immediately below the layer name at the top of the layer's description page).

Make sure you have your credentials set up to access your account via the CLI (using either an IAM user or IAM Identity Center SSO).

Once you have the ARN you can use the CLI to retrieve a Cloudformation file that will allow you to deploy the lambda layer into your account. _Important distinction_: We talk about two ARNs here. One is the ARN of the layer in the Serverless Repository, the other will be the ARN of the layer as deployed into your account.

```sh
aws serverlessrepo create-cloud-formation-template     \
    --application-id ARN_FROM_SERVERLESS_REPO          \
    --query='TemplateURL'                              \
    | xargs curl > TEMPORARY_CFN_FILE.yml
```

Now, using the temporary Cloudformation YAML file, deploy the lambda layer to your account. Once it's deployed you can retrieve **its** ARN and use that in your main Cloudformation file. _You **can not** use the ARN from the layer's description page itself. You must deploy it to your own account._ I like to use `deploy` for the Cloudformation command because it's synchronous.

```sh
aws cloudformation deploy \
 --stack-name DEPLOY_LAYER_STACK_NAME \
 --template-file TEMPORARY_CFN_FILE.yml
```

Use the CLI to query the stack and verify that the stack deployed correctly.

```sh
aws cloudformation list-stacks
aws cloudformation describe-stacks --stack-name DEPLOY_LAYER_STACK_NAME
aws lambda list-layers
```

Test the lambda, and it's use of the layer, with:

```sh
aws lambda invoke --function-name test-lambda-layer out.json
```
