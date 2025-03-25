# **Terragrunt Best Practices - Complete Reference Guide**

## **1. Project Structure**
A well-organized structure ensures maintainability and scalability.

### **Recommended Structure**
```
.
├── modules/                  # Reusable Terraform modules
│   ├── vpc/
│   ├── eks/
│   └── alb/
├── live/                     # Environment-specific configs
│   ├── dev/
│   │   ├── vpc/
│   │   │   └── terragrunt.hcl
│   │   ├── eks/
│   │   └── alb/
│   └── prod/
│       ├── vpc/
│       ├── eks/
│       └── alb/
└── terragrunt.hcl            # Root-level config
```

### **Key Points**
- **Modules** should be **provider-agnostic** (no hardcoded regions/profiles).
- **Environments** (`dev`, `prod`) should have identical module structures.
- **Root `terragrunt.hcl`** defines **shared configurations** (backend, common variables).

---

## **2. Keeping Configurations DRY**
### **Use `include` to Inherit Configs**
```hcl
# live/dev/vpc/terragrunt.hcl
include {
  path = find_in_parent_folders() # Inherits root settings
}

inputs = {
  vpc_cidr = "10.0.0.0/16"
}
```

### **Centralize Common Variables**
```hcl
# Root terragrunt.hcl
locals {
  common_tags = {
    Environment = "dev"
    ManagedBy   = "Terragrunt"
  }
  
  aws_region = "us-east-1"
}
```

### **Merge Inputs for Flexibility**
```hcl
# live/dev/eks/terragrunt.hcl
inputs = merge(
  local.common_tags,
  {
    cluster_name = "dev-eks"
    node_type    = "t3.medium"
  }
)
```

---

## **3. Managing Remote State**
### **Configure Backend in Root**
```hcl
# Root terragrunt.hcl
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    bucket         = "my-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.aws_region
    dynamodb_table = "terraform-locks"
  }
}
```

### **Key Points**
- **`path_relative_to_include()`** ensures unique state paths per module.
- **DynamoDB** for state locking (prevents concurrent modifications).
- **`generate`** auto-creates `backend.tf` in each module.

---

## **4. Provider Configuration**
### **Generate Provider Dynamically**
```hcl
# Root terragrunt.hcl
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents = <<EOF
provider "aws" {
  region  = "${local.aws_region}"
  profile = "${local.aws_profile}"
}
EOF
}
```

### **Per-Environment Overrides**
```hcl
# live/prod/terragrunt.hcl
locals {
  aws_profile = "prod-profile" # Overrides root
}
```

---

## **5. Version Pinning**
### **Lock Terraform & Provider Versions**
```hcl
# Root terragrunt.hcl
generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents = <<EOF
terraform {
  required_version = "= 1.5.7" # Strict versioning

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Allows patches (5.0.x)
    }
  }
}
EOF
}
```

### **Key Points**
- **`=`** for exact versions (recommended in production).
- **`~>`** allows patch updates (e.g., `~> 5.0` means `5.0.x`).

---

## **6. Managing Multiple Environments**
### **Environment-Specific Variables**
```hcl
# live/dev/terragrunt.hcl
locals {
  env_name = "dev"
  instance_type = "t3.small"
}
```

```hcl
# live/prod/terragrunt.hcl
locals {
  env_name = "prod"
  instance_type = "m5.large"
}
```

### **Reuse Modules with Different Inputs**
```hcl
# live/dev/vpc/terragrunt.hcl
inputs = {
  cidr_block = "10.1.0.0/16"
  tags = merge(local.common_tags, { Name = "dev-vpc" })
}
```

```hcl
# live/prod/vpc/terragrunt.hcl
inputs = {
  cidr_block = "10.2.0.0/16"
  tags = merge(local.common_tags, { Name = "prod-vpc" })
}
```

---

## **7. Dependency Management**
### **Define Dependencies Explicitly**
```hcl
# live/dev/eks/terragrunt.hcl
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.private_subnets
}
```

### **Key Points**
- **`dependency`** blocks ensure correct execution order.
- **`config_path`** points to dependent modules.

---

## **8. Workspace & CLI Best Practices**
### **Use `run-all` for Multi-Module Operations**
```bash
terragrunt run-all plan  # Plans all modules in a directory
terragrunt run-all apply # Applies all changes
```

### **Pass Variables via CLI**
```bash
terragrunt apply -var="instance_type=t3.large"
```

---

## **9. CI/CD Integration**
### **Sample GitHub Actions Workflow**
```yaml
jobs:
  deploy:
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3
      - run: terragrunt run-all plan
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

---

## **10. Security & Compliance**
### **Use IAM Roles Instead of Hardcoded Creds**
```hcl
generate "provider" {
  contents = <<EOF
provider "aws" {
  region = "us-east-1"
  assume_role {
    role_arn = "arn:aws:iam::123456789012:role/TerraformRole"
  }
}
EOF
}
```

### **Encrypt Sensitive Inputs**
```hcl
inputs = {
  db_password = get_env("DB_PASSWORD") # Load from env vars
}
```

---

## **Final Checklist**
✅ **DRY Principle**: Reuse configurations via `include` and `locals`.  
✅ **State Management**: Use S3 + DynamoDB for locking.  
✅ **Version Pinning**: Lock Terraform & provider versions.  
✅ **Modularity**: Keep modules independent and reusable.  
✅ **Environment Isolation**: Separate `dev`/`prod` cleanly.  
✅ **Dependencies**: Use `dependency` blocks for correct ordering.  
✅ **Security**: Avoid hardcoding secrets, use IAM roles.  

---

This guide covers **Terragrunt best practices** for **scalable, maintainable, and secure** infrastructure. Bookmark it for future reference! 🚀