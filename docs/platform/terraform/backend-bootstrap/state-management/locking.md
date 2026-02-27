# State Locking

S3 supports native state locking when `use_lockfile = true` is configured in the backend.

## Enabling S3 Native Locking

```hcl
terraform {
  backend "s3" {
    bucket       = "gitops-tfstate-a1b2c3d4"
    key          = "module/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

???+ warning "Not Enabled by Default"
    `use_lockfile` defaults to `false`. If omitted, no state locking occurs.

## How Locking Works

1. `terraform plan` or `terraform apply` attempts to acquire a lock.
2. Terraform creates a `.tflock` file in S3 next to the state file.
3. The lock is released when the operation completes.

If a second operation starts, Terraform detects the existing lock and waits or fails based on configuration.

## Lock Entry Structure

Lock entries include:

- Lock ID (matches the state file path)
- Who holds the lock (user, hostname)
- When the lock was acquired
- Operation being performed

## Handling Stuck Locks

```bash
terraform force-unlock <LOCK_ID>
```

Only force unlock when you are certain no operation is running.

For full operational guidance, see [Terraform State Lock Errors](state-lock-errors.md).
