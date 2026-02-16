# Terraform Backend Bootstrap

The bootstrap module creates the AWS infrastructure required for Terraform remote state management across the platform.

## What It Creates

Located in `infra/bootstrap/`, this one-time setup provisions:

- **S3 Bucket**: Stores Terraform state files with versioning and encryption enabled
- **Random Suffix**: Ensures globally unique S3 bucket naming

The S3 bucket is configured with versioning, which is required for S3's native state locking feature. However, modules using this backend must explicitly enable locking by setting `use_lockfile = true` in their backend configuration.

See the full resource definitions in `infra/bootstrap/main.tf`.

## S3 Native State Locking

S3 provides native state locking capabilities. Key points:

- **Explicit Enablement**: Modules must set `use_lockfile = true` in backend configuration
- **Not Automatic**: Locking defaults to `false` and must be explicitly enabled
- **Versioning Required**: The S3 bucket must have versioning enabled
- **Lock Files**: Terraform creates `.tflock` files in S3 to manage concurrent operations

???+ info "Why S3 Native Locking?"
    See [S3 Native Locking](../../../thinking/s3-native-locking.md) for details on this architectural decision.

See [Using the Backend](usage.md#understanding-s3-native-locking) for detailed configuration instructions.

## Why Local State

The bootstrap itself uses **local state** (stored in `infra/bootstrap/terraform.tfstate`). This deliberate choice avoids a chicken-and-egg problem: you cannot store state in S3 before the S3 bucket exists.

This is documented in `infra/bootstrap/backend.tf`:

> "This bootstrap module uses LOCAL state because it creates the S3 bucket used for remote state."

If the local state is lost, the bootstrap can be safely re-imported or recreated—it's a one-off operation not intended for frequent modification.

## Configuration

Default configuration values in `infra/bootstrap/variable.tf`:

| Variable             | Default                | Description                                 |
| -------------------- | ---------------------- | ------------------------------------------- |
| `region`             | `ap-south-1`           | AWS region (Mumbai)                         |
| `bucket_name_prefix` | `gitops-tfstate`       | S3 bucket name prefix (random suffix added) |
| `tags`               | `{Project, ManagedBy}` | Minimal resource tags                       |

???+ info "One-time operation"
	The bootstrap defines your remote state backend. Run it once per environment and reuse the outputs; re-running will create a new bucket suffix, so stash the output values somewhere safe.

## Documentation

- **[Applying the Bootstrap](applying.md)** - How to run the bootstrap process
- **[Using the Backend](usage.md)** - Configuring other Terraform modules to use the backend
- **[State Management](state-management.md)** - Understanding local vs remote state
- **[Destroying the Bootstrap](destroying.md)** - Cleanup and removal procedures

## Related Documentation

- [Architecture](../../platform/architecture.md) - Overall infrastructure architecture
- [Mise Configuration](../../dev/mise/index.md) - Tool management including Terraform
