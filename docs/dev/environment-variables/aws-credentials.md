# AWS Credentials

AWS credentials can be provided in two ways. The devcontainer exposes whichever credentials are available.

=== "Host machine (recommended)"

    If you have AWS CLI configured on your host machine:

    ```bash
    aws configure
    ```

    Credentials from `~/.aws/credentials` are mounted into the devcontainer.

=== "Environment variables"

    If AWS CLI is not configured on your host, uncomment and configure these variables in `.env`:

    ```bash
    AWS_ACCESS_KEY_ID=your_access_key_here
    AWS_SECRET_ACCESS_KEY=your_secret_key_here
    AWS_DEFAULT_REGION=ap-south-1
    ```

## Credential Precedence

Environment variables override `~/.aws/credentials`. Double-check which credentials are active before running destructive commands.
