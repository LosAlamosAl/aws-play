## AWS Cognoto User Pool Signup Confirmation Notification Test

The Cognito user pool creation stuff is stolen from [Sander Knape's blog post](https://sanderknape.com/2020/08/amazon-cognito-jwts-authenticate-amazon-http-api/). The notification work (except for lambda) is mine.

Use `Makefile` to CRUD (create, read, update, delete) the stack. Edit the `Makefile` and insert your own `stack_name`. Command line parameters to `make` are needed to set lambda environment variables (via Cloudformation parameters).

First time, create the stack:

```sh
make create VERIFIED_FROM_EMAIL="username@your_verified_domain" \
            ALERT_TO_EMAIL="username@your_verified_email"
```

where `VERIFIED_FROM_EMAIL` is the sending email address of your notification email. AWS SES (their email sending service) requires that this domain be verified (at least if you're still in the Cognito sandbox). The `username` portion of the email address can be anything, only `your_verified_domain` must be verified by AWS. See this [page](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html) for the (admittedly tedious) domain verification procedure.

Sending from a verified domain is advantageous for a number of reasons, one of which it that the recipient's email will show a `From` field with your domain. In this case, if you're just sending notification emails to yourself, you can use another verified email address as the `VERIFIED_FROM_EMAIL`. This will save you the hassle of verifying a domain with the only downside being that the `From` filed of the email will show `E-mail Gateway`.

The `ALERT_TO_EMAIL` is where you're sending your notificatons to. This too must be verified by AWS. In this case the email address itself is verified, not the domain. This requires a response to an initial email that AWS will send to the address. You can initiate this process with the AWS CLI (V2 here):

```sh
aws ses verify-email-identity --email-address username@your_verified_email
```

Once you reply to the email from AWS, this address will be verified.
TODO: note about Pushover and whether it can be directly verified without forwarding. Of course, this can also be accomplished from the console, but I prefer the CLI whenever possible.

Subsequnet changes, update the stack:

```sh
make update VERIFIED_FROM_EMAIL="username@your_verified_domain" \
            ALERT_TO_EMAIL="username@your_verified_email"
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

To confirm the signup (this would normally happen when the user replys to the signup email. However, all that is sent in this example is a confirmation code--no reply requested?). The `--user-pool-id` parameter is output from the stack as `UserPoolId`.

```sh
aws cognito-idp admin-confirm-sign-up --user-pool-id UserPoolId --username 'user@doofus.com'
```

At this point you should see a notification email at `ALERT_TO_EMAIL` that was sent from `VERIFIED_FROM_EMAIL`.
