# Documentation Deployment Workflow

**File:** [`.github/workflows/docs.yml`](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.github/workflows/docs.yml)

## Purpose

Automatically builds and deploys documentation to GitHub Pages whenever docs are updated on `main`.

## How It Works

### Automatic Trigger

Fires on `push` to `main` when any of these paths change:

- `docs/**` — Any documentation file
- `zensical.toml` — Documentation config file

### Manual Trigger

Invoke via `workflow_dispatch` to rebuild and redeploy docs on demand.

## Steps

1. **Configure GitHub Pages** using `actions/configure-pages`
2. **Checkout repository** at the current commit
3. **Setup Python 3.14** runtime
4. **Install zensical** documentation builder via pip
5. **Build site** with `zensical build --clean`
   - `--clean` flag removes previous build artifacts
   - Outputs built site to `site/` directory (by default)
6. **Upload pages artifact** from `site/` directory
7. **Deploy to GitHub Pages** (environment: `github-pages`)

## Outputs

The workflow deploys to GitHub Pages and outputs the deployment URL (available in `steps.deployment.outputs.page_url`).

## Permissions Required

- `contents: read` — Read repository content during build
- `pages: write` — Deploy to GitHub Pages
- `id-token: write` — Generate OIDC token for Pages deployment

## Documentation Structure

The documentation is built from the `docs/` directory using `zensical` and the configuration in `zensical.toml`.

Key folders:

- `docs/dev/` — Developer experience (tools, setup, branching)
- `docs/platform/` — Platform and infrastructure architecture
- `docs/services/` — Service specifications and endpoints
- `docs/thinking/` — Decisions, narrative, and journey docs

## Site Output

The built site is output to the `site/` directory with:

- `site/index.html` — Homepage
- `site/**/*.html` — Rendered documentation pages
- `site/assets/` — CSS, JavaScript, and images
- `site/search.json` — Search index
- `site/sitemap.xml` — Sitemap for crawlers

## Configuration

Documentation build behavior is configured in:

- `zensical.toml` — Site title, theme, structure, build options
- `docs/` folder layout — Navigation structure (folders map to navigation)

## Automatic Build on Changes

This workflow automatically re-deploys the site whenever:

1. Documentation files change on `main`
2. Configuration changes (e.g., theme updates to `zensical.toml`)
3. Manually triggered via `workflow_dispatch`

No documentation is "staged" or "pending"—all docs on `main` are live on the public Pages site.

## Related Workflows

Documentation deployment is independent of the release pipeline. It can happen on its own schedule and does not depend on service version bumps or artifact publishing.
