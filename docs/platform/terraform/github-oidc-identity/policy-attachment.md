# Policy Attachment

The role created by [infra/identity/main.tf](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/infra/identity/main.tf) has no permissions until policies are attached.

## Attach Policy in Terraform

Add to `infra/identity/main.tf`:

```hcl
resource "aws_iam_role_policy_attachment" "workflow_access" {
  role       = module.github_oidc_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
```

Apply:

```bash
terraform -chdir=infra/identity plan
terraform -chdir=infra/identity apply
```

## Verify

Get role name:

```bash
terraform -chdir=infra/identity output role_name
```

List attached policies:

```bash
aws iam list-attached-role-policies --role-name <role_name>
```

## Principle

Attach only permissions required by the workflow.
