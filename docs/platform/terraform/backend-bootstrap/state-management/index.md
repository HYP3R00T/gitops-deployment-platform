# State Management

This section explains how Terraform state is stored, locked, recovered, and protected.

## What This Covers

- Local vs remote state usage
- S3 native locking configuration
- Backup and recovery with versioning
- Security and handling of sensitive data

## Topics

- [Local vs Remote State](local-vs-remote.md) - Where state lives and why
- [State Locking](locking.md) - S3 native locking setup and behavior
- [State Lock Errors](state-lock-errors.md) - What to do when lock acquisition fails
- [Backup and Recovery](backup-recovery.md) - Version history and restore workflow
- [Security Considerations](security.md) - Protecting state files and access

## Best Practices

1. Never edit state manually. Use `terraform state` commands instead.
2. Keep bootstrap state safe. `infra/bootstrap/terraform.tfstate` is critical.
3. Monitor lock duration to catch stuck operations early.
4. Review state changes with `terraform plan` before `apply`.
