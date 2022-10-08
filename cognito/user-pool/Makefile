stack_name = aws-play--cognito-user-pool
cfn_file = user-pool.yml

.PHONY: create
create:
	@set -e                                                                      ;\
	aws cloudformation deploy --stack-name $(stack_name)                          \
		--template-file $(cfn_file)                                               \
		--capabilities CAPABILITY_NAMED_IAM

update: $(cfn_file)
	@set -e                                                                      ;\
	aws cloudformation deploy --stack-name $(stack_name)                          \
		--template-file $(cfn_file)                                               \
		--capabilities CAPABILITY_NAMED_IAM

.PHONY: read
read:
	aws cloudformation describe-stacks --stack-name $(stack_name)

.PHONY: delete
delete:
	aws cloudformation delete-stack --stack-name $(stack_name)