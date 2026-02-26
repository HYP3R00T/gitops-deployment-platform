# Security Considerations

Terraform state can contain sensitive data. Treat it as a secret.

## State Files Contain Sensitive Data

- Resource IDs
- IP addresses
- Database connection strings
- Secrets and credentials

## Protection Mechanisms

1. Encryption at rest via S3 server-side encryption
2. Encryption in transit via HTTPS
3. Access control with bucket policies and IAM roles
4. Git ignore for all state files

???+ warning "Treat state as secrets"
    Always assume state files contain sensitive data. Store them securely and limit IAM access.

## What Not to Do

- Do not commit state files to Git
- Do not share state files via email or chat
- Do not store state in public S3 buckets
- Do not disable S3 encryption
