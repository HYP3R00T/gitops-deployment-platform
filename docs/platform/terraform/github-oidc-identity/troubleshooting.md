# Troubleshooting

Common failures for the current OIDC setup.

## 1) Missing `id-token: write`

If OIDC token requests fail, ensure workflow permissions include:

```yaml
permissions:
  id-token: write
  contents: read
```

## 2) Trust Policy Mismatch

If `AssumeRoleWithWebIdentity` is denied, verify values in [terraform.tfvars](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/terraform.tfvars):

- `github_org`
- `github_repositories`

Then re-apply:

```bash
terraform -chdir=infra/identity apply
```

## 3) Role Has No Permissions

If authentication succeeds but AWS API calls return `AccessDenied`, attach required policies.

See [Policy Attachment](policy-attachment.md).

## Quick Checks

```bash
terraform -chdir=infra/identity output role_arn
terraform -chdir=infra/identity output role_name
aws iam list-open-id-connect-providers
aws iam list-attached-role-policies --role-name <role_name>
```
