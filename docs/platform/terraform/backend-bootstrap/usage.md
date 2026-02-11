# Using the Backend in Other Modules

All Terraform modules outside of bootstrap should configure remote state to use the S3 bucket and DynamoDB table created by the bootstrap process.

## Retrieving Backend Configuration

After applying the bootstrap, retrieve the S3 bucket name:

```bash
terraform -chdir=infra/bootstrap output -raw s3_bucket_name
```

You can also get a complete backend configuration snippet:

```bash
terraform -chdir=infra/bootstrap output backend_config
```

## Configuring Backend in Modules

Add the backend configuration to your module's Terraform configuration:

```hcl
terraform {
  backend "s3" {
    bucket         = "<s3_bucket_name from output>"
    key            = "<module-name>/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

### Backend Configuration Parameters

| Parameter        | Value                             | Description                                |
| ---------------- | --------------------------------- | ------------------------------------------ |
| `bucket`         | From bootstrap output             | S3 bucket name (includes random suffix)    |
| `key`            | `<module-name>/terraform.tfstate` | Path within bucket for this module's state |
| `region`         | `ap-south-1`                      | AWS region (must match bootstrap)          |
| `dynamodb_table` | `terraform-state-lock`            | DynamoDB table for state locking           |
| `encrypt`        | `true`                            | Enable server-side encryption              |

=== "Development configuration"

```hcl
terraform {
  backend "s3" {
    bucket         = "gitops-tfstate-a1b2c3d4"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

=== "Production configuration"

```hcl
terraform {
  backend "s3" {
    bucket         = "gitops-tfstate-a1b2c3d4"
    key            = "prod/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

## Initializing with Remote Backend

After adding the backend configuration, initialize the module:

```bash
terraform -chdir=<module-path> init
```

Terraform will:

1. Configure the S3 backend
2. Acquire a lock in DynamoDB
3. Create or retrieve the state file from S3

## Migrating from Local to Remote State

If you have existing local state, Terraform will prompt you to migrate it:

```bash
terraform -chdir=<module-path> init

# Terraform will ask: "Do you want to copy existing state to the new backend?"
# Answer: yes
```

This safely migrates your local state file to S3.

## Best Practices

1. **Use descriptive keys**: Name state files after their purpose (`dev/vpc.tfstate`, `prod/eks.tfstate`)
2. **One state file per environment**: Keep environments isolated
3. **Document backend config**: Include backend configuration in module READMEs
4. **Verify state location**: After init, confirm state is in S3 with `terraform state list`
