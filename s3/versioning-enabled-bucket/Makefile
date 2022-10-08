stack_name = aws-play--s3-versioning-enabled-bucket
cfn_file = versioned-bucket.yml
bucket_name = losalamosal--aws-play--versioned-bucket

.PHONY: create
create:
	@set -e                                                                      ;\
	aws cloudformation deploy --stack-name $(stack_name)                          \
		--template-file $(cfn_file)                                               \
		--parameter-overrides VersionedBucketName=$(bucket_name)                  \
		--capabilities CAPABILITY_NAMED_IAM

update: $(cfn_file)
	@set -e                                                                      ;\
	aws cloudformation deploy --stack-name $(stack_name)                          \
		--template-file $(cfn_file)                                               \
		--parameter-overrides VersionedBucketName=$(bucket_name)                  \
		--capabilities CAPABILITY_NAMED_IAM

.PHONY: read
read:
	aws cloudformation describe-stacks --stack-name $(stack_name)

.PHONY: delete
delete:
	aws cloudformation delete-stack --stack-name $(stack_name)