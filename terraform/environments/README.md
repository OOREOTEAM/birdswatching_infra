## Terraform Environments

This directory contains the terraform configuration for deploying application to different environments `dev_01`, `stage_01`).
It uses modules from the `modules/` directory to build the infrastructure.

### Project Structure

`main.tf`: The main entrypoint that defines the module blocks.

`workspace_vars/tfvars`: Defines the input variables for the configuration.

`backend.tf`: Configures the S3 remote state backend for enviroments. (\*uses existing S3 bucket)

`dev_01.tfvars`: Contains the variable values for the development environment

`stage_01.tfvars`: Contains the variable values for the staging environment

`modules/`: Contains reiqured modules to build BirdWatching project infrastructure

### Local usage

Deploying the `dev_01` environment (\*note this is an example, team shoud use Jenkins for deployment )

Using `Makefile` run commands:

Initialize Terraform:
It configures the backend to point to the correct state file.

```bash
make init             #in this case default ENV=stage_01 (stage_1 workspace)
make init ENV=dev-01  #in this case ENV=dev_01 (dev_1 workspace)

```

Select or create workspace:
The init command in Makefile includes workspace creation/selection

Plan:
Create an execution plan to see what will change

```bash
make plan             #(stage_1 workspace)
make plan ENV=dev_01  #(dev_1 workspace)
```

Apply: It applies the configuration to create or update the infrastructure

```bash
make apply             #(stage_1 workspace)
make apply ENV=dev_01  #(dev_1 workspace)
```

Destroy: It deletes all infrastructure configutarion, do NOT use without need

```bash
make destroy             #(stage_1 workspace)
make destroy ENV=dev_01  #(dev_1 workspace)
```
