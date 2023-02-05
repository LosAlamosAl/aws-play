## AWS Cognoto User Pool Test

All stolen from [Sander Knape's blog post](https://sanderknape.com/2020/08/amazon-cognito-jwts-authenticate-amazon-http-api/).

Use `Makefile` to CRUD (create, read, update, delete) the stack. Edit the `Makefile` and insert your own `stack_name`. First time, create the stack:

```sh
make create`
```

Subsequnet changes, update the stack:

```sh
make update
```

To see the stack's outputs (which are used in the following shell commands):

```sh
make read
```

To delete the stack:

```sh
make delete
```

To test the stack, first signup a user. The `--client-id` parameter is output from the stack as `UserPoolClientId`.

```sh
aws cognito-idp sign-up --client-id UserPoolClientId --username 'user@doofus.com' --password 'Crust123!'
```

To confirm the signup (I assume this would normally happen when the user replys to the signup email. However, all that is sent in this example is a confirmation code--no reply requested?). The `--user-pool-id` parameter is output from the stack as `UserPoolId`.

```sh
aws cognito-idp admin-confirm-sign-up --user-pool-id UserPoolId --username 'user@doofus.com'
```

Finally, to get a JWT access token:

```sh
aws cognito-idp initiate-auth --client-id UserPoolClientId --auth-flow USER_PASSWORD_AUTH \
  --auth-parameters USERNAME='user@doofus.com',PASSWORD='Crust123!'
```
