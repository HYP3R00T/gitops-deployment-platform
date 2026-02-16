# Migration to S3 Native State Locking

## Background

Historically, Terraform's S3 backend required a DynamoDB table to provide state locking functionality. This meant provisioning and managing two separate AWS services:

1. **S3 bucket** - For storing state files
2. **DynamoDB table** - For managing locks during Terraform operations

## The Change

As of recent Terraform versions, S3 now supports native state locking without requiring DynamoDB. This is a significant improvement that simplifies infrastructure and reduces costs.

## Why We Migrated

### Simplified Architecture

- **Before**: Required managing S3 bucket + DynamoDB table
- **After**: Only requires S3 bucket with versioning enabled

### Reduced Costs

- **Before**: Paid for both S3 storage and DynamoDB read/write capacity
- **After**: Only S3 storage costs (DynamoDB charges eliminated)

### Fewer Moving Parts

- **Before**: Two services that could fail or be misconfigured
- **After**: Single service providing both state storage and locking

### Same Reliability

S3's native locking provides the same protection against concurrent state modifications. The locking mechanism uses `.tflock` files stored in S3 alongside the state files.

## Implementation Details

### How S3 Native Locking Works

When `use_lockfile = true` is configured in the backend:

1. Terraform creates a `.tflock` file in S3 before operations
2. The lock file contains metadata (user, hostname, timestamp, operation)
3. Other operations detect the lock and wait or fail
4. The lock is released when the operation completes

### Configuration Requirement

The feature must be explicitly enabled:

```hcl
terraform {
  backend "s3" {
    bucket       = "state-bucket"
    key          = "terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    use_lockfile = true  # Required - defaults to false
  }
}
```

**Critical**: The `use_lockfile` parameter defaults to `false`. If omitted, no state locking occurs.

### S3 Bucket Requirements

The S3 bucket must have:

- **Versioning enabled** - Required for the locking mechanism to work properly
- **Encryption enabled** - Best practice for state file security

## Benefits for This Project

1. **Simpler Bootstrap**: The bootstrap module only creates one resource (S3 bucket)
2. **Lower Operational Overhead**: One less service to monitor and maintain
3. **Cost Savings**: No DynamoDB charges for state locking operations
4. **Easier Disaster Recovery**: Fewer components to restore

## Migration Notes

For teams migrating from DynamoDB-based locking:

1. Update backend configurations to include `use_lockfile = true`
2. Remove `dynamodb_table` parameter from backend blocks
3. The DynamoDB table can be safely deleted after migration
4. No state migration required - only configuration changes

## References

- [Terraform S3 Backend Documentation](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- Article: [Goodbye DynamoDB — Terraform S3 Backend Now Supports Native Locking](https://rafaelmedeiros94.medium.com/goodbye-dynamodb-terraform-s3-backend-now-supports-native-locking-06f74037ad39)
