## AWS Play: Deploy Lambda Layer with CLI and CFN

This repo contains two shell scripts (`deployall.sh` and `deleteall.sh`) that test the process of automatically installing a lambda layer from the [Serverless Repository](https://aws.amazon.com/serverless/serverlessrepo/). The scripts also test that the installation of the layer was successful. In this repo we work specifically with the [`lambda-layer-canvas-nodejs`](https://serverlessrepo.aws.amazon.com/applications/us-east-1/990551184979/lambda-layer-canvas-nodejs) but the code should work with any layer in the Serverless Repository.

> Please see my [blog post]() on this topic for a full explanation of the process and commands used in the scripts.

### Requirements

- [AWS CLI Version 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- `curl`, `bash`
- Appropriate credential to deploy to target AWS account (unfortunately `admin` because an IAM policy is created)

### Running the Scripts

First run `deployall.sh` to install and test the layer, and then `deleteall.sh` to remove all the resources that have been installed in your account. The scripts themselves are commented. The following sections describe the actions of each script.

#### `deployall.sh`

The `deployall.sh` script works as follows:

1. Retrieve a Cloudformation template from the Serverless Repository that will deploy the lambda layer into your account. Store the template in a temporary file.
1. Run Cloudformation on the template to create a stack (`lambda-layer-stack`) with a resource for the lambda layer. The layer is now deployed to your account.
1. Use the AWS CLI to extract the ARN of the layer that was just deployed into your account.
1. Use Cloudformation to deploy another stack, `layer-test-stack`, which will test that the layer was installed into our account successfully. The YAML file `lambda_with_layer.yml` is the source for this stack. The ARN of the layer to test is passed as a parameter to the Cloudformation run.
1. Confirm that the layer was correctly installed by invoking the test lambda. The output from this lambda function is displayed in the terminal.
1. Finally, delete the temporary template retrieved in Step 1.

Before running `deleteall.sh` you can explore the resources created in your account by playing with some of these AWS CLI commands:

```sh
aws cloudformation describe-stacks ...
aws lambda list-layers ...
aws lambda invoke ...
aws lambda list-layer-versions ...
```

#### `deleteall.sh`

The `deleteall.sh` script the deletes previously installed resources from your account. In detail:

1. Use Cloudformation to delete the `lambda-layer-stack`.
1. Use Cloudformation to delete the `layer-test-stack`.
1. The layer itself is not deleted by Cloudformation since, by default, its `DeletionPolicy` is `RETAIN`.
1. Get the **latest version** of the layer and manually delete it using the AWS CLI. PLease see the [blog post]() for potential _gotchas_ with lambda layer versions and how to delete **all** versions of an installed layer.

### Disclaimer

These scripts install few resources (a lambda layer, a test lambda function, and lambda logs) and we only execute the test lambda once (or a few times if you play around with it) so runaway AWS bills should be unlikely. However, as with all things AWS, there is potential for billing surprises and I make no promise that there won't be any with this code. **Use at your own risk**.

I developed this code at age 67.
