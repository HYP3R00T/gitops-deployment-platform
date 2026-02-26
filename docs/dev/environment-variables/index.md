# Environment Variables

This section covers how environment variables are stored, managed, and used across the project.

## Configuration File

The environment configuration is stored in `.env` (gitignored). A template is provided at [.env.example](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.env.example).

To set up your environment:

```bash
cp .env.example .env
# Edit .env with your actual values
```

???+ info "Store secrets safely"
    Keep `.env` gitignored, and never paste its contents into issue trackers, chats, or PRs.

## Environment File Structure

```bash
# GitHub Authentication
MISE_GITHUB_TOKEN=ghp_xxxxx
GITHUB_TOKEN=ghp_xxxxx

# AWS Credentials (optional - uncomment if needed)
# AWS_ACCESS_KEY_ID=xxxxx
# AWS_SECRET_ACCESS_KEY=xxxxx
# AWS_DEFAULT_REGION=ap-south-1

# Service Configuration
PUBLIC_API_URL=http://api:8000
```

## Topics

- [GitHub Tokens](github-tokens.md) - Required tokens and permissions
- [AWS Credentials](aws-credentials.md) - Host and environment variable options
- [Service Configuration](service-configuration.md) - PUBLIC_API_URL usage
- [Security and Troubleshooting](security-and-troubleshooting.md) - Common issues and safeguards
