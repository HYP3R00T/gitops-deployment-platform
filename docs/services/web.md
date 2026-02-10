# Web Service

Astro-based frontend that surfaces backend status and metadata for the GitOps platform. It renders static content plus runtime checks against the API service.

## Purpose

- Provide a human-facing status surface for the platform
- Display health and metadata from the API service
- Keep UI simple, deterministic, and lightweight

## Runtime

- Framework: Astro
- Adapter: `@astrojs/node` (standalone server output)
- Styling: Tailwind CSS (via `@tailwindcss/vite`)

## Configuration

The frontend reads the API base URL from environment:

| Setting | Required | Description |
| --- | --- | --- |
| `PUBLIC_API_URL` | Yes | Base URL for API requests (e.g. `http://localhost:8000`) |

## Pages

| Route | Description | API Dependency |
| --- | --- | --- |
| `/` | Overview and navigation | None |
| `/status` | Backend health status | `GET /health` |
| `/info` | Backend metadata display | `GET /info` |

## API Integration

API calls use native `fetch()` directly in each page's frontmatter following Astro's recommended pattern for SSR. Each page wraps fetch in try-catch and returns a normalized `{ ok, data, error }` result object to avoid throwing exceptions during rendering.

## Local Development

From the repository root:

```bash
pnpm --dir services/web install
PUBLIC_API_URL=http://localhost:8000 pnpm --dir services/web dev --host 0.0.0.0
```

Build and preview:

```bash
pnpm --dir services/web build
pnpm --dir services/web preview
```
