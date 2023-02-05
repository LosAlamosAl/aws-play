stack_name = aws-play--signup-confirm-notification
cfn_file = user-pool.yml

.PHONY: create
create:
	@set -e                                                                      ;\
	aws cloudformation deploy --stack-name $(stack_name)                          \
		--template-file $(cfn_file)                                               \
		--parameter-overrides VerifiedFromEmail=$(VERIFIED_FROM_EMAIL)            \
		                      AlertToEmail=$(ALERT_TO_EMAIL)                      \
		--capabilities CAPABILITY_NAMED_IAM

update: $(cfn_file)
	@set -e                                                                      ;\
	aws cloudformation deploy --stack-name $(stack_name)                          \
		--template-file $(cfn_file)                                               \
		--parameter-overrides VerifiedFromEmail=$(VERIFIED_FROM_EMAIL)            \
		                      AlertToEmail=$(ALERT_TO_EMAIL)                      \
		--capabilities CAPABILITY_NAMED_IAM

.PHONY: read
read:
	aws cloudformation describe-stacks --stack-name $(stack_name)

.PHONY: delete
delete:
	aws cloudformation delete-stack --stack-name $(stack_name)