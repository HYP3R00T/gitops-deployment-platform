# Local vs Remote State

This project uses local state for the bootstrap module and remote state for all other modules.

## Local State (Bootstrap Only)

**Location:** `infra/bootstrap/terraform.tfstate`

**Why local state:** The bootstrap creates the S3 bucket used for remote state. Local state avoids the circular dependency.

## Remote State (All Other Modules)

**Location:** S3 bucket created by the bootstrap

**Why remote state:** Shared access, locking, encryption, and version history.

## State File Structure

### Bootstrap State

```text
infra/bootstrap/
├── terraform.tfstate
└── terraform.tfstate.backup
```

### Remote State in S3

```text
s3://gitops-tfstate-<random>/
├── dev/terraform.tfstate
├── prod/terraform.tfstate
└── modules/vpc/terraform.tfstate
```

Each module has its own state file, identified by the `key` parameter in its backend configuration.
