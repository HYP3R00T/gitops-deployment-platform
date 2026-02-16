# State Management

Understanding how Terraform state is managed across the bootstrap and other modules.

## Local vs Remote State

### Local State

**Used by**: Bootstrap module only

**Location**: `infra/bootstrap/terraform.tfstate`

**Characteristics**:

- File stored on local disk
- Not shared across users
- No locking mechanism
- Git-ignored for security

**Why bootstrap uses local state**:

The bootstrap creates the S3 bucket used for remote state. This creates a chicken-and-egg problem: you cannot store state in S3 before the bucket exists.

By using local state for the bootstrap, we avoid this circular dependency. The bootstrap is a one-time operation that creates the infrastructure needed for all other modules to use remote state.

### Remote State

**Used by**: All other Terraform modules

**Location**: S3 bucket created by bootstrap

**Characteristics**:

- Stored in S3 with versioning enabled
- Shared across team members
- State locking via S3 native locking
- Encrypted at rest
- Version controlled (via S3 versioning)

**Benefits**:

1. **Collaboration**: Multiple team members can work with the same state
2. **Safety**: State locking prevents concurrent modifications
3. **Durability**: S3 provides redundancy and backup
4. **History**: S3 versioning enables state recovery

## State File Structure

### Bootstrap State

```sh
infra/bootstrap/
├── terraform.tfstate          # Current local state
└── terraform.tfstate.backup   # Previous local state
```

Both files are git-ignored for security.

### Remote State in S3

```sh
s3://gitops-tfstate-<random>/
├── dev/terraform.tfstate          # Development environment
├── prod/terraform.tfstate         # Production environment
└── modules/vpc/terraform.tfstate  # Shared module state
```

Each module has its own state file, identified by the `key` parameter in the backend configuration.

## State Locking

### Enabling S3 Native Locking

S3 supports native state locking, but it must be explicitly enabled in your backend configuration:

```hcl
terraform {
  backend "s3" {
    bucket       = "gitops-tfstate-a1b2c3d4"
    key          = "module/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true  # Required - defaults to false
  }
}
```

???+ warning "Not Enabled by Default"
    The `use_lockfile` parameter defaults to `false`. If you omit it, **no state locking will occur**, even though S3 supports the feature.

### How It Works

1. When `terraform plan` or `terraform apply` runs with `use_lockfile = true`, Terraform:
    - Attempts to acquire a lock using S3's native locking mechanism
    - Creates a `.tflock` file in S3 alongside the state file
    - Proceeds with the operation
    - Releases the lock when complete

2. If another operation is in progress:
    - Terraform detects the existing lock in the `.tflock` file
    - Displays who holds the lock and when it was acquired
    - Waits or fails depending on configuration

### Lock Entry Structure

S3 native lock entries (stored in `.tflock` files) include:

- Lock ID (matches state file path)
- Who holds the lock (user, hostname)
- When the lock was acquired
- Operation being performed

### Handling Stuck Locks

If a Terraform operation is interrupted, the lock might remain:

```bash
# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

**Warning**: Only force unlock if you're certain no operation is running.

## State Backup and Recovery

### S3 Versioning

The bootstrap enables versioning on the S3 bucket. Every state update creates a new version, allowing recovery from:

- Accidental modifications
- Corrupt state files
- Deleted resources

### Recovering Previous State

List all versions:

```bash
aws s3api list-object-versions \
  --bucket <bucket-name> \
  --prefix <key>
```

Download a specific version:

```bash
aws s3api get-object \
  --bucket <bucket-name> \
  --key <key> \
  --version-id <version-id> \
  terraform.tfstate.backup
```

Restore the version:

```bash
# Backup current state first
terraform state pull > current_state_backup.json

# Push the recovered state
terraform state push terraform.tfstate.backup
```

## Best Practices

1. **Never edit state manually**: Use `terraform state` commands instead
2. **Keep bootstrap state safe**: The `infra/bootstrap/terraform.tfstate` file is critical
3. **Monitor lock duration**: Long-running locks may indicate issues
4. **Review state changes**: Use `terraform plan` before `apply`
5. **Regular state backups**: Even with S3 versioning, maintain offline backups for critical infrastructure

## Security Considerations

### State Files Contain Sensitive Data

Terraform state files may include:

- Resource IDs
- IP addresses
- Database connection strings
- Secrets and credentials

### Protection Mechanisms

1. **Encryption at rest**: S3 server-side encryption enabled
2. **Encryption in transit**: HTTPS for all S3 operations
3. **Access control**: S3 bucket policies and IAM roles
4. **Git ignore**: All state files excluded from version control

???+ warning "Treat state as secrets"
  Always assume every state file contains sensitive data. Store them securely, never share them, and limit IAM access to the credentials that really need to read them.

### What NOT to Do

- ❌ Commit state files to Git
- ❌ Share state files via email or chat
- ❌ Store state in public S3 buckets
- ❌ Disable S3 encryption

## Related Documentation

- [Applying the Bootstrap](applying.md) - Creating the backend infrastructure
- [Using the Backend](usage.md) - Configuring modules to use remote state
- [Destroying the Bootstrap](destroying.md) - Cleanup procedures
