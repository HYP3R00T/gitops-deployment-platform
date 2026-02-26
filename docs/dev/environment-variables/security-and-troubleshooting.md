# Security and Troubleshooting

## Security Best Practices

1. Never commit `.env` to version control
2. Use `.env.example` as a template
3. Rotate tokens regularly
4. Use minimal permissions
5. Set token expiration dates
6. Store sensitive values securely
7. Do not share tokens

## Troubleshooting

### mise cannot install tools

- Check that `MISE_GITHUB_TOKEN` is set correctly
- Verify required permissions (`repo`, `read:packages`)
- Check for token expiration

### AWS commands fail with authentication errors

- Verify AWS credentials are configured (host machine or `.env`)
- Check credential file format: `~/.aws/credentials`
- Ensure `AWS_DEFAULT_REGION` is set if using environment variables

### Web service cannot connect to API

- Verify `PUBLIC_API_URL` points to the correct host and port
- Check that the API service is running
- Verify network connectivity between services
