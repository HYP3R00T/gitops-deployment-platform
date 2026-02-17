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

| Setting          | Required | Description                                              |
| ---------------- | -------- | -------------------------------------------------------- |
| `PUBLIC_API_URL` | Yes      | Base URL for API requests (e.g. `http://localhost:8000`) |

???+ warning "Keep API URL accurate"
	If `PUBLIC_API_URL` points to the wrong service, the entire UI will render stale or fail silently. Update this value whenever the API host/port changes and redeploy the web service.

## Pages

| Route     | Description              | API Dependency |
| --------- | ------------------------ | -------------- |
| `/`       | Overview and navigation  | None           |
| `/status` | Backend health status    | `GET /health`  |
| `/info`   | Backend metadata display | `GET /info`    |

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

## Container Build

The web service uses a multi-stage Dockerfile to separate the build environment from the runtime environment, reducing the final image size and excluding development dependencies from production. See `services/web/Dockerfile` for the complete specification.

### Build Stage (node:20-alpine)

The first stage compiles Astro source code into production-ready static and server assets.

**Key steps:**

1. Accept `PUBLIC_API_URL` as a build argument (defaults to `http://localhost:8000`)
2. Copy `package.json` and `pnpm-lock.yaml` first for layer caching
3. Install dependencies with `pnpm install --frozen-lockfile` (ensures reproducible builds)
4. Copy all source files
5. Set `PUBLIC_API_URL` as environment variable for the build process
6. Run `pnpm build` to compile assets into `dist/`

???+ warning "Build-time vs Runtime: PUBLIC_API_URL"
	Astro (via Vite) bakes `PUBLIC_*` environment variables into the JavaScript bundle at **build time**. Changing `PUBLIC_API_URL` at runtime has no effect. The value must be provided as a build argument when building the image.

	This is why Docker Compose passes `PUBLIC_API_URL: http://api:8000` as a build arg—it ensures the compiled JavaScript makes API calls to the correct service name within the Docker network.

### Runtime Stage (node:20-alpine)

The second stage creates the final image containing only production artifacts.

**What's copied:**

- `dist/` directory (compiled Astro app with SSR server)
- `package.json` (required for Node.js module resolution)

**What's excluded:**

- Source files (`src/`, `astro.config.mjs`)
- Development dependencies (`node_modules/`)
- Build tools and caches

This reduces the final image size from ~500MB to ~150MB.

### Layer Caching Strategy

The build separates dependency installation from source code copying:

1. Copy `package.json` and `pnpm-lock.yaml`
2. Run `pnpm install` (cached if lockfile unchanged)
3. Copy source files (invalidates cache only for subsequent layers)

This optimization means changing a single Astro component doesn't require reinstalling all npm packages.

### Reproducibility

The `--frozen-lockfile` flag forces pnpm to use exact versions from `pnpm-lock.yaml`. If the lockfile is out of sync with `package.json`, the build fails rather than silently installing different versions. This ensures every build produces byte-identical output given the same inputs.
