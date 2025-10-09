.PHONY: init plan apply destroy
ENV=stage_01

init:
	terraform init
	terraform workspace select -or-create ${ENV}

plan: init
	terraform plan -var-file=workspace_vars/${ENV}.tfvars

apply: init
	terraform apply -var-file=workspace_vars/${ENV}.tfvars
destroy: init
	terraform destroy -var-file=workspace_vars/${ENV}.tfvars