## Experiments with AWS: Deploy Lambda Layer with CLI and CFN

See the blog post for a detailed writeup. This repo is an abbreviated description the tests the process of automatically installing the layer and testing its availability to a published lambda function.

Requirements:

- [AWS CLI Version 2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- `curl`, `sed`
- Appropriate credential to deploy to target AWS account

Steps:

Get ARN of lambda layer from the [AWS Serverless Repository](https://serverlessrepo.aws.amazon.com/applications). There appears to be no way to query the repo symbolically. You must search for the layer on the site and copy it's ARN (listed in tiny text immediately below the layer name at the top of the layer's description page) manually.

Make sure you have your credentials set up to access your account via the CLI (using either IAM an IAM user or IAM Identity Center single signon).

Once you have the ARN yo ucan use the CLI to retrieve a Cloudformation file that will allow you to deploy the lambda layer into your account.

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

Query the stack and use the CLI to verify that the stack deployed correctly.

```sh
aws cloudformation list-stacks
aws cloudformation describe-stacks --stack-name DEPLOY_LAYER_STACK_NAME
aws lambda list-layers
```
