# aws-play

Experiments with AWS

Requirements:

- AWS CLI Version 2 installed

Steps:

1. Get AEN of lambda layer from the (AWS Serverless Repository)[https://serverlessrepo.aws.amazon.com/applications]. There appears to be no way to query the repo symbolically. You must search for the layer on the site and copy it's ARN (listed in tiny text immediately below the layer name at the top of the layer's description page) manually.

1. Make sure you have your credentials set up to access your account via the CLI (using either IAM an IAM user or IAM Identity Center single signon).

1. Once you have the ARN yo ucan use the CLI to retrieve a Cloudformation file that will allow you to deploy the lambda layer into your account.

```sh
aws serverlessrepo create-cloud-formation-template     \
    --application-id ARN_FROM_SERVERLESS_REPO          \
    --query='TemplateURL' > TEMPORARY_CFN_FILE.yml
```

1. Now, using the temporary Cloudformation YAML file, deploy the lambda layer to your account. Once it's deployed you can retrieve **its** ARN and use that in your main Cloudformation file. _You **can not** use the ARN from the layer's description page itself. You must deploy it to your own account._
