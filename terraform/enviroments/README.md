## Terraform Environments

This directory contains the terraform configuration for deploying application to different environments `dev`, `staging`).
It uses modules from the `modules/` directory to build the infrastructure.

### Project Structure

`main.tf`: The main entrypoint that defines the module blocks.

`variables.tf`: Defines the input variables for the configuration.

`backend.tf`: Configures the S3 remote state backend for enviroments. (\*uses existing S3 bucket)

`dev.tfvars.json`: Contains the variable values for the development environment

`stage.tfvars.json`: Contains the variable values for the staging environment

`modules/`: Contains the reusable modules for networking, security, and resourses(EC2)

### Local usage

Deploying the `dev` Environment (\*note this is an example, team shoud use Jenkins for deployment )

Initialize Terraform:
This only needs to be done once per environment. It configures the backend to point to the correct state file.

```bash
terraform init -backend-config="key=dev/terraform.tfstate
```

Select or create workspace:

```bash
terraform workspace select dev || terraform workspace new dev
```

Plan and Apply:
Use the `dev.tfvars.json` file to apply the development configuration

```bash
terraform plan -var-file="dev.tfvars.json"
terraform apply -var-file="dev.tfvars.json"
```

### Jenkins Deployment

WIP
