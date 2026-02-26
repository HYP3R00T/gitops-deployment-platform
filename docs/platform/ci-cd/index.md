# CI/CD Workflows

This section documents the automated workflows that manage service releases, artifact publishing, and documentation deployment.

## Quick Navigation

- [Pipeline Overview](overview.md) — End-to-end release workflow and trigger conditions
- [Bump API Workflow](bump-api.md) — Automated version bumping and release PR creation
- [Create Release Tag](create-release.md) — Git tag creation when release PRs merge
- [Publish Artifacts](publish-artifacts.md) — Docker image building, registry push, and GitHub release creation
- [Documentation Deployment](docs-deployment.md) — Automated docs build and GitHub Pages deployment

## The Release Pipeline at a Glance

The platform uses a **staged release workflow** triggered by code changes and pulled together in GitHub Actions:

1. **Bump** → Commits to `services/api/**` automatically trigger `Bump API` workflow, which creates a release PR with version bump and changelog
2. **Tag** → When the release PR is merged, `Create Release Tag` workflow creates a Git tag (e.g., `api-v1.2.3`)
3. **Publish** → The tag triggers `Publish Artifacts` workflow, which builds Docker image and creates a GitHub release
4. **Docs** → Changes to `docs/**` trigger documentation build and auto-deploy to GitHub Pages

All workflows run on Ubuntu Latest with minimal, scoped permissions per GitHub best practices.
