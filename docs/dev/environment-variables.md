# Environment Variables

This project uses environment variables for configuration, managed through a `.env` file in the workspace root. The `.env` file is loaded automatically by mise and makes variables available to all tools and tasks.

## Configuration File

The environment configuration is stored in `.env` (gitignored). A template is provided at `.env.example` for reference.

To set up your environment:

```bash
cp .env.example .env
# Edit .env with your actual values
```

???+ info "Store secrets safely"
    Keep the `.env` file gitignored, and never paste its contents into issue trackers, chats, or PRs. Treat it as the single source of sensitive configuration for your workspace.

## GitHub Tokens

The project requires GitHub tokens for API access and private repository operations. Two separate tokens are configured to provide granular access control.

???+ info "Token hygiene"
    Store `MISE_GITHUB_TOKEN` and `GITHUB_TOKEN` only in `.env`, rotate them if a leak is suspected, and never share token values publicly.

### MISE_GITHUB_TOKEN

Used exclusively by mise for:

- Installing tools from private GitHub repositories
- Avoiding GitHub API rate limiting during tool installation
- Accessing mise-specific GitHub integrations

**Required Permissions:**

- `repo` (if accessing private repositories)
- `read:packages` (for GitHub Packages access)

### GITHUB_TOKEN

Used by various project tools and scripts for:

- GitHub Actions workflows (if running locally)
- Git operations requiring authentication
- GitHub CLI (`gh`) commands
- Repository management scripts

**Required Permissions:**

- `repo` (full control of private repositories)
- `workflow` (if triggering GitHub Actions)
- Additional permissions as needed for specific operations

### Why Two Separate Tokens?

While a single token could technically work for both purposes, using separate tokens provides several advantages:

1. **Principle of Least Privilege**: Each token can be configured with only the permissions it needs
2. **Security Isolation**: If one token is compromised, the other remains secure
3. **Audit Trail**: Separate tokens make it easier to track which tool performed which operation
4. **Rotation Management**: Tokens can be rotated independently without affecting all tools
5. **Access Control**: Different tokens can have different expiration dates and scopes

You can use the same token value for both if simplicity is preferred, but separate tokens are recommended for production environments.

### Generating GitHub Tokens

1. Go to [GitHub Settings > Developer settings > Personal access tokens > Tokens (classic)](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Give your token a descriptive name (e.g., "mise-gitops-platform" or "gitops-platform-general")
4. Select the required permissions based on the token's purpose
5. Set an appropriate expiration date
6. Generate and copy the token
7. Add it to your `.env` file

## AWS Credentials

AWS credentials can be provided in two ways, depending on your setup. The devcontainer exposes whichever credentials are available.

=== "Host machine (recommended)"

If you have AWS CLI configured on your host machine:

```bash
aws configure
```

Credentials from `~/.aws/credentials` are automatically mounted into the devcontainer and available to all AWS tools.

=== "Environment variables"

If AWS CLI is not configured on your host, uncomment and configure these variables in `.env`:

```bash
AWS_ACCESS_KEY_ID=your_access_key_here
AWS_SECRET_ACCESS_KEY=your_secret_key_here
AWS_DEFAULT_REGION=ap-south-1
```

**When to use this method:**

- AWS CLI is not installed on your host machine
- You want to use different credentials than your host configuration
- You're using temporary credentials (STS tokens)
- You're in a CI/CD environment

???+ warning "Credential precedence"
    Environment variables override `~/.aws/credentials`. Double-check which credentials are active before running destructive commands.

## Service Configuration

### PUBLIC_API_URL

Specifies the API endpoint URL for the web service.

**Default**: `http://localhost:8000`

**Usage**:

- The web service uses this URL to connect to the API service
- Change this when running services on different hosts or ports
- In production, this would point to your actual API endpoint

**Examples**:

```bash
# Local development (default)
PUBLIC_API_URL=http://localhost:8000

# Custom port
PUBLIC_API_URL=http://localhost:3001

# Remote API
PUBLIC_API_URL=https://api.example.com
```

## Environment File Structure

The `.env` file follows this structure:

```bash
# GitHub Authentication
MISE_GITHUB_TOKEN=ghp_xxxxx
GITHUB_TOKEN=ghp_xxxxx

# AWS Credentials (optional - uncomment if needed)
# AWS_ACCESS_KEY_ID=xxxxx
# AWS_SECRET_ACCESS_KEY=xxxxx
# AWS_DEFAULT_REGION=ap-south-1

# Service Configuration
PUBLIC_API_URL=http://localhost:8000
```

## Security Best Practices

1. **Never commit `.env` to version control** - It's gitignored by default
2. **Use `.env.example` as a template** - This can be safely committed
3. **Rotate tokens regularly** - Especially if they might have been exposed
4. **Use minimal permissions** - Only grant what each token needs
5. **Set token expiration dates** - Avoid tokens that never expire
6. **Store sensitive values securely** - Consider using a password manager
7. **Don't share tokens** - Each developer should have their own tokens

## Troubleshooting

### mise cannot install tools

- Check that `MISE_GITHUB_TOKEN` is set correctly
- Verify the token has necessary permissions (`repo`, `read:packages`)
- Check for token expiration

### AWS commands fail with authentication errors

- Verify AWS credentials are configured (either host machine or `.env`)
- Check credential file format: `~/.aws/credentials`
- Ensure `AWS_DEFAULT_REGION` is set if using environment variables

### Web service cannot connect to API

- Verify `PUBLIC_API_URL` points to the correct host and port
- Check that the API service is running
- Verify network connectivity between services

## Related Documentation

- [Developer Setup](developer-setup.md) - Initial environment setup
- [Terraform Backend Bootstrap](../platform/terraform/backend-bootstrap/index.md) - AWS credentials for infrastructure provisioning
