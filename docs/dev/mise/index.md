# Mise Configuration

This project uses [mise](https://mise.jdx.dev/) (formerly rtx) for managing development tools and task automation. The `mise.toml` configuration file defines all CLI tools, environment variables, and common tasks for the project.

## What is Mise?

Mise is a polyglot tool version manager and task runner that:

- **Manages multiple language runtimes** - Python, Node.js, etc.
- **Installs CLI tools** - AWS CLI, Terraform, kubectl, and more
- **Defines project tasks** - Reusable commands for common operations
- **Sets environment variables** - Project-specific configuration
- **Ensures consistency** - Everyone uses the same tool versions

???+ info "Activation matters"
	Mise runs as soon as you enter the project directory. If a tool feels missing, double-check that mise is activated (`mise which <tool>`) before reinstalling tools manually.

## Why Mise?

While the devcontainer provides a consistent base environment, mise offers additional benefits:

1. **Declarative tool management** - All tools defined in one file
2. **Version pinning** - Lock specific versions or use latest
3. **Automatic activation** - Tools available when entering the directory
4. **Task runner** - Centralized scripts with mise commands
5. **Works everywhere** - In devcontainer, CI/CD, or local development

## Documentation

- **[Configuration](configuration.md)** - Tools, settings, hooks, environment variables, and tasks
- **[Usage](usage.md)** - Installation, running tasks, adding tools, and checking versions
- **[Best Practices](best-practices.md)** - Guidelines for tool versions, tasks, and environment variables
- **[Troubleshooting](troubleshooting.md)** - Common issues and solutions

## Related Documentation

- [Developer Setup](../developer-setup.md) - Overall development environment setup
- [Environment Variables](../environment-variables.md) - Configuration and secrets management
- [Pre-commit Hooks](../pre-commit-hooks/index.md) - Automated code quality checks
- [Local Kubernetes](../../platform/local-kubernetes.md) - Kind cluster setup and usage
- [Terraform Backend Bootstrap](../../platform/terraform/backend-bootstrap/index.md) - Infrastructure state management

## Further Reading

- [Mise Official Documentation](https://mise.jdx.dev/)
- [Mise on GitHub](https://github.com/jdx/mise)
- [Comparison with other tools](https://mise.jdx.dev/comparison.html)
