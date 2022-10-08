## AWS S3 Versioning-Enabled Bucket Test

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

Use the command line to copy fils to the bucket and inspect versions:

```sh
aws s3 cp Makefile s3://losalamosal--aws-play--versioned-bucket
aws s3 cp Makefile s3://losalamosal--aws-play--versioned-bucket
aws s3 cp Makefile s3://losalamosal--aws-play--versioned-bucket
aws s3 cp Makefile s3://losalamosal--aws-play--versioned-bucket
aws s3 cp Makefile s3://losalamosal--aws-play--versioned-bucket
aws s3api list-object-versions --bucket losalamosal--aws-play--versioned-bucket
```

TODO: Enable bucket logging to verify lifecyle rules.
