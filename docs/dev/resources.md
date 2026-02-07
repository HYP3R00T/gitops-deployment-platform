# Resources

Tools, frameworks, and standards used in this project.

## Repository & Project Governance

How this repo behaves socially and structurally. These are the expectations, norms, and responsibilities that humans read first.

### Contribution & Conduct

- [Code of Conduct](https://www.contributor-covenant.org/) - Community behavior standards
- [PR Template](https://docs.github.com/en/communities/using-templates-to-encourage-useful-issues-and-pull-requests/creating-a-pull-request-template-for-your-repository) - Standardized pull request format
- [Writing Great Pull Request Descriptions](https://www.hackerone.com/blog/writing-great-pull-request-description) - Best practices for PR communication

### Ownership & Stewardship

- [Code Owners](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners) - Code ownership and review responsibility
- [GitHub Funding](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/displaying-a-sponsor-button-in-your-repository) - Support and sponsorship documentation

### Repository Configuration

- [gitignore](https://git-scm.com/docs/gitignore) - Exclude files from version control

## Developer Environment & Workflow

What a contributor needs on their machine. Everything here runs before CI ever sees the code.

### Version Control & Editing

- [Git](https://git-scm.com/) - Version control system
- [VSCode](https://code.visualstudio.com/) - Code editor
- [EditorConfig](https://editorconfig.org/) - Consistent editor configuration

### Local Environment

- [Development Containers](https://containers.dev/) - Standardized dev environments
- [mise](https://mise.jdx.dev/) - Polyglot version manager and task runner

### Code Quality & Commits

- [Pre-commit](https://pre-commit.com/) - Git hooks framework for code quality
- [Commitizen](https://commitizen-tools.github.io/commitizen/) - Conventional commit tooling
- [Conventional Commits](https://www.conventionalcommits.org/) - Commit message specification

## Languages, Toolchains & Build

How source code turns into artifacts. Language-specific sprawl belongs here.

### Python Toolchain

- [Python](https://www.python.org/) - Primary programming language (3.14+)
- [uv](https://docs.astral.sh/uv/) - Fast Python package installer and resolver
- [ruff](https://docs.astral.sh/ruff/) - Fast Python linter and formatter

### Build & Packaging

- [Docker](https://www.docker.com/) - Container runtime and image building

## Automation, CI & Delivery

How the repo operates without humans. The mechanical spine of the project.

### Continuous Integration

- [GitHub Actions](https://github.com/features/actions) - CI/CD pipeline automation

### Dependency & Supply Chain

- [Dependabot](https://dependabot.com/) - Automated dependency updates
- [Dependabot Guide](https://docs.github.com/en/code-security/tutorials/secure-your-dependencies/dependabot-quickstart-guide) - Setup and usage documentation

## Infrastructure & Runtime

Where this actually runs. Everything here assumes code already exists.

### Infrastructure as Code

- [Terraform](https://www.terraform.io/) - Infrastructure as Code (IaC) provisioning
- [AWS](https://aws.amazon.com/) - Cloud provider (EKS, VPC, IAM, CloudWatch)

### Orchestration & Clusters

- [Kubernetes](https://kubernetes.io/) - Container orchestration platform
- [Kind](https://kind.sigs.k8s.io/) - Local Kubernetes cluster for development

### Reliability & Health

- [Kubernetes API](https://kubernetes.io/docs/reference/kubernetes-api/) - Workload declarations
- [Health Check Patterns](https://en.wikipedia.org/wiki/Health_check_(computing)) - Service liveness validation

## AI Assistance & Automation Context

How AI is guided inside this repository. Intentional automation context that scales later.

- [Repository Custom Instructions for GitHub Copilot](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions) - Context for AI-assisted development
