# Backup and Recovery

S3 versioning provides history and recovery for Terraform state.

## S3 Versioning

Every state update creates a new version, allowing recovery from accidental changes or deletion.

## Recovering Previous State

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
terraform state pull > current_state_backup.json
terraform state push terraform.tfstate.backup
```
