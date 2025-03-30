# Interview Questions
1. Difference b/w terraform and cloudformation
`Terraform` and `CFT` both are IAC tools

- TF is a cloud agnostic tools means you can create infrastructure on multiple cloud providers
- TF we develope modules to reuse the IAC code again and again
- TF maintains statefile to track the resources created by tf
- No built in rollback requires manual intervention
- You can detect drift by terraform plan

- CFT is IAC tool only AWS
- No built-in module system (but uses nested stacks)
- CFT does not maintain any state
- automatic rollback in failure
- AWS provides drift detection separately

2. How do you manage secrets in terraform
3. How do you manage multiple environemnts in terraform
4. What is terraform how can you manage statefile
5. You need to manage secrets in your terraform such as API keys database passwords how can you handle sensitive data
    - Vault → If using HashiCorp Vault.
    - AWS Secrets Manager / SSM → For AWS-based infrastructure.
    - Environment variables → For local development.
    - Terraform Cloud Vault → If using Terraform Cloud.


# Terraform folder structure to project management

- Apply Infra code reusable by implement modules[DRY principle]
- Store the state file in remote store and implment dynamodb locking avoid parallel execution
- encrypt the infrastructure by using KMS key
- Don't plance any sensitive data by using AWS secret store or HashiCorp Vault

1. expense-project/
- Modules/
  - vpc/
  - sg/
- environemtns
  - dev/
    - vpc/
    - sg/
  - prod/
    - vpc/
    - sg/
- each and every module intialization you to maintain provider.tf in environments
- In this folder structure I observer few things have more repeat code managing depecies some what difficult for example i want out puts of vpc I need to store vpc related out values in aws parameter store and get the values into sg same way remainning also

2. expense-project/
- Modules/
- environments/
  - dev/
    - main.tf
    - terraform.tfvars
    - outputs.tf
    - variables.tf
  - prod/
    - main.tf
    - terraform.tfvars
    - outputs.tf
    - variables.tf
- All modules are defined in files some what it will confuse us and it's like more attention required

3. expense-project/
- Modules/
- Modules call
- using workspaces to manage differnt environemnts more careful and attention required

4. 
 
