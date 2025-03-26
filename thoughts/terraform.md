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
