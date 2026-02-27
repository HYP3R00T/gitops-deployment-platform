# Terraform State Lock Errors

Use this runbook when Terraform fails with `Error acquiring the state lock` against the S3 backend.

## Scope

- Backend: S3 remote state with `use_lockfile = true`
- Audience: operators running Terraform locally and CI maintainers
- Goal: recover safely without risking concurrent state writes

## Symptom

Typical error output:

```text
Error: Error acquiring the state lock
... api error PreconditionFailed: At least one of the pre-conditions you specified did not hold
Lock Info:
  ID: <LOCK_ID>
```

## Why This Happens

- Terraform acquires an exclusive lock before operations that can change state.
- If a previous process crashes or exits unexpectedly, the lock can remain.
- A new run cannot proceed until the lock is released.

## Can S3 Locking Use Timeout Policies?

No backend-level lock timeout policy is available in S3 locking.

- S3 native locking is enabled with `use_lockfile = true`.
- Terraform supports waiting for lock acquisition with CLI retry timeout (`-lock-timeout`), but this is command behavior, not an S3 lock expiration policy.
- If lock acquisition still fails, manual intervention is required.

## Safe Resolution Procedure

1. Confirm no Terraform run is active for the same state path (local terminal, CI job, or other operator).
2. Re-run with a wait timeout when appropriate:

   ```bash
   terraform plan -lock-timeout=10m
   ```

3. If the lock is stale, force unlock using the lock ID from the error:

   ```bash
   terraform force-unlock <LOCK_ID>
   ```

4. Re-run `terraform plan` and verify the lock is acquired normally.

## CI Policy

- Use `-lock-timeout` for `plan` and `apply` in workflows.
- Serialize Terraform jobs per environment or state.
- Do not auto-run `terraform force-unlock` in CI.
- If timeout is exceeded, fail the job and perform a manual stale-lock check.

## Known Edge Case

- Track [hashicorp/terraform#37324](https://github.com/hashicorp/terraform/issues/37324) for an S3 locking retry edge case.
- Treat this as implementation caveat guidance, not a reason to bypass locking.

## References

- [Terraform state locking](https://developer.hashicorp.com/terraform/language/state/locking)
- [Terraform S3 backend (`use_lockfile`)](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- [Terraform CLI `plan` options (`-lock-timeout`)](https://developer.hashicorp.com/terraform/cli/commands/plan)
- [Terraform CLI `force-unlock`](https://developer.hashicorp.com/terraform/cli/commands/force-unlock)
- [AWS backend best practices](https://docs.aws.amazon.com/prescriptive-guidance/latest/terraform-aws-provider-best-practices/backend.html)
