# GitHub Tokens

GitHub tokens are required for API access and private repository operations. Two tokens are used to keep access scoped and auditable.

## MISE_GITHUB_TOKEN

Used by mise for:

- Installing tools from private GitHub repositories
- Avoiding GitHub API rate limits during tool installation
- Accessing mise-specific GitHub integrations

**Required permissions:**

- `repo` (if accessing private repositories)
- `read:packages`

## GITHUB_TOKEN

Used by project tools for:

- GitHub Actions workflows (if running locally)
- Git operations requiring authentication
- GitHub CLI (`gh`) commands
- Repository management scripts

**Required permissions:**

- `repo`
- `workflow` (if triggering GitHub Actions)

## Why Two Tokens

- Principle of least privilege
- Security isolation
- Clear audit trail
- Independent rotation

You can use the same token value for both, but separate tokens are recommended for production environments.

## Generating Tokens

1. Go to [GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Choose a descriptive name
4. Select the required permissions
5. Set an expiration date
6. Generate and copy the token
7. Add it to your `.env` file
