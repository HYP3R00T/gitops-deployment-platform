# Using the Backend in Other Modules

All Terraform modules outside of bootstrap should configure remote state to use the S3 bucket created by the bootstrap process. S3 provides native state locking capabilities that must be explicitly enabled by setting `use_lockfile = true` in your backend configuration.

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
    bucket       = "<s3_bucket_name from output>"
    key          = "<module-name>/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true  # Required to enable S3 native locking
  }
}
```

### Backend Configuration Parameters

| Parameter      | Value                             | Description                                       |
| -------------- | --------------------------------- | ------------------------------------------------- |
| `bucket`       | From bootstrap output             | S3 bucket name (includes random suffix)           |
| `key`          | `<module-name>/terraform.tfstate` | Path within bucket for this module's state        |
| `region`       | `ap-south-1`                      | AWS region (must match bootstrap)                 |
| `encrypt`      | `true`                            | Enable server-side encryption                     |
| `use_lockfile` | `true`                            | **Required** to enable S3 native state locking    |

=== "Development configuration"

```hcl
terraform {
  backend "s3" {
    bucket       = "gitops-tfstate-a1b2c3d4"
    key          = "dev/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

=== "Production configuration"

```hcl
terraform {
  backend "s3" {
    bucket       = "gitops-tfstate-a1b2c3d4"
    key          = "prod/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

## Understanding S3 Native Locking

### The `use_lockfile` Flag

S3 supports native state locking, but it's **not enabled by default**. You must explicitly enable it by setting `use_lockfile = true` in your backend configuration.

???+ warning "Required for State Locking"
    If you omit `use_lockfile = true`, Terraform will **not** use state locking, even though the S3 bucket supports it. The default value is `false`.

### How It Works

When `use_lockfile = true` is configured:

1. Terraform creates a `.tflock` file in S3 alongside your state file
2. Before any operation, Terraform attempts to acquire the lock by creating/updating this file
3. The lock includes metadata: who holds it, when it was acquired, and what operation is running
4. After the operation completes, Terraform releases the lock
5. If another operation is already in progress, Terraform will detect the lock and wait or fail

### Benefits

- **Single Service**: Uses only S3 for both storage and locking
- **Lower Costs**: No additional services required for locking
- **Simpler Infrastructure**: Fewer resources to manage
- **Concurrent Protection**: Prevents simultaneous state modifications

## Initializing with Remote Backend

After adding the backend configuration, initialize the module:

```bash
terraform -chdir=<module-path> init
```

Terraform will:

1. Configure the S3 backend
2. Acquire a lock using S3 native locking
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
