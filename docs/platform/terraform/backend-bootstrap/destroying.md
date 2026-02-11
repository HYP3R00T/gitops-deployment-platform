# Destroying the Bootstrap

???+ warning
Destroying the bootstrap deletes the S3 bucket and DynamoDB table used for Terraform state storage. Ensure no other Terraform modules are using this backend before proceeding.

## Prerequisites for Destruction

Before destroying the bootstrap infrastructure:

1. **Migrate or destroy all other Terraform modules** that use this backend
2. **Ensure the S3 bucket is empty** - Terraform cannot delete non-empty S3 buckets by default
3. **Backup any important state files** from the S3 bucket if needed

## Step 1: Verify Dependencies

Check which modules are using the backend:

```bash
# List all state files in the bucket
BUCKET_NAME=$(terraform -chdir=infra/bootstrap output -raw s3_bucket_name)
aws s3 ls s3://${BUCKET_NAME} --recursive
```

If you see any state files, you must handle them first (see below).

## Step 2: Handle Existing State Files

For each module using the backend:

### Option A: Destroy the Module

```bash
terraform -chdir=<module-path> destroy
```

This removes both the infrastructure and the state file.

### Option B: Migrate to Local State

If you want to preserve the module but stop using remote state:

```bash
# Remove backend configuration from module
# Then reinitialize to migrate state
terraform -chdir=<module-path> init -migrate-state
```

## Step 3: Empty the S3 Bucket

Even after destroying all modules, the S3 bucket must be completely empty.

### Remove All Objects

```bash
BUCKET_NAME=$(terraform -chdir=infra/bootstrap output -raw s3_bucket_name)

# Remove all objects
aws s3 rm s3://${BUCKET_NAME} --recursive
```

### Remove All Versions (if versioning is enabled)

```bash
# Delete all versions and delete markers
aws s3api delete-objects --bucket ${BUCKET_NAME} \
  --delete "$(aws s3api list-object-versions \
  --bucket ${BUCKET_NAME} \
  --query '{Objects: Versions[].{Key:Key,VersionId:VersionId}}' \
  --output json)"

# Delete delete markers
aws s3api delete-objects --bucket ${BUCKET_NAME} \
  --delete "$(aws s3api list-object-versions \
  --bucket ${BUCKET_NAME} \
  --query '{Objects: DeleteMarkers[].{Key:Key,VersionId:VersionId}}' \
  --output json)"
```

### Verify Bucket is Empty

```bash
aws s3 ls s3://${BUCKET_NAME} --recursive
# Should return nothing
```

## Step 4: Destroy the Bootstrap

Once prerequisites are met:

```bash
terraform -chdir=infra/bootstrap destroy
```

Terraform shows a plan of resources to be deleted:

- S3 bucket
- DynamoDB table
- Random string resource

Review and confirm the destruction.

## Step 5: Verify Cleanup

After destruction:

```bash
# Check local state shows zero resources
terraform -chdir=infra/bootstrap show

# Verify AWS resources are gone
aws s3 ls | grep gitops-tfstate
aws dynamodb list-tables | grep terraform-state-lock
```

## Post-Destruction

After destroying the bootstrap:

1. The local state file `infra/bootstrap/terraform.tfstate` shows zero resources
2. All AWS resources (S3 bucket and DynamoDB table) are deleted
3. You can re-run the bootstrap process if needed - the random suffix generates a new unique bucket name

## Troubleshooting

### "Bucket not empty" error

Terraform cannot delete non-empty S3 buckets. Follow Step 3 to empty the bucket completely, including all versions.

### "Resource in use" error

The DynamoDB table may have active locks. Wait for any running Terraform operations to complete, or force-unlock if necessary.

### Partial Deletion

If destruction fails partway through:

```bash
# Check what's left
terraform -chdir=infra/bootstrap state list

# Manually remove specific resources from AWS if needed
aws s3 rb s3://${BUCKET_NAME} --force
aws dynamodb delete-table --table-name terraform-state-lock

# Remove from state
terraform -chdir=infra/bootstrap state rm <resource>
```

## When to Destroy the Bootstrap

Destroy the bootstrap when:

- **Decommissioning the project** - No longer using Terraform
- **Migrating to new backend** - Moving to a different state storage solution
- **Starting fresh** - Rebuilding infrastructure from scratch
- **Testing** - Practicing bootstrap procedures in development

**Do NOT destroy when**:

- Other modules are actively using the backend
- You're unsure about dependencies
- State files haven't been backed up

## Related Documentation

- [State Management](state-management.md) - Understanding local vs remote state
- [Using the Backend](usage.md) - How modules use the backend
- [Applying the Bootstrap](applying.md) - Re-creating the backend after destruction
