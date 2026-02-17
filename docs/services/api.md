# API Service

Minimal stateless backend for GitOps demonstrations. It exposes a fixed v1 contract for health and metadata checks and keeps all state in memory.

## Purpose

- Provide deterministic responses for platform validation
- Serve as a probe target for deployment, failure, and recovery flows
- Keep behavior static and predictable across restarts

???+ note "Stateless safety"
	The API keeps all state in memory on purpose. Any behavior relying on persistence should be considered intentionally out of scope for this reference service.

## Runtime

- Framework: FastAPI
- Entry point: `api.main:main`
- Default bind: `0.0.0.0:8000`

## Configuration

Configuration is intentionally minimal and loaded from environment using `utilityhub_config`. The only defined setting is:

| Setting    | Type   | Default | Description               |
| ---------- | ------ | ------- | ------------------------- |
| `app_name` | string | `api`   | Service name used in logs |

## API Contract

| Endpoint      | Response                                                                                                                      | Notes                                        |
| ------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| `GET /`       | `{"service": "gitops-deployment-platform", "status": "ok"}`                                                                   | Static metadata                              |
| `GET /health` | `{"healthy": true}`                                                                                                           | Returns 200 when healthy, 503 when unhealthy |
| `GET /info`   | `{"name": "gitops-deployment-platform", "description": "Minimal backend for GitOps demonstrations", "environment": "static"}` | Static metadata                              |

## Behavior

- Stateless in-memory health flag (resets on restart)
- No persistence, database, or external dependencies
- Errors are surfaced via typed exceptions and exit with non-zero status

## Local Development

From the repository root:

```bash
cd services/api
uv sync
uv run api
```

Run tests:

```bash
uv run pytest
```

## Container Build

The API service uses a single-stage Dockerfile optimized for fast Python package installation and minimal image size. See `services/api/Dockerfile` for the complete build specification.

### Base Image

**python:3.14-slim** — Minimal Debian-based Python distribution (~50MB vs ~900MB for the full variant). Contains only essential system libraries required to run Python.

### Package Installation Strategy

The build copies the `uv` binary from `ghcr.io/astral-sh/uv:0.10.3` instead of installing it via pip. This multi-stage copy pattern avoids pulling the entire uv base image while gaining access to Astral's fast package installer (~10x faster than pip).

???+ tip "UV system mode"
	The build sets `UV_SYSTEM_PYTHON=1` to install packages directly into the system Python environment. Virtual environments are unnecessary inside containers since the container itself provides isolation.

### Layer Caching Optimization

The Dockerfile copies `pyproject.toml` before copying source code. This leverages Docker's layer caching: if dependencies haven't changed, the `uv pip install` layer is reused from cache, dramatically speeding up rebuilds during development.

**Build order:**

1. Copy dependency specification (`pyproject.toml`)
2. Install dependencies (cached layer)
3. Copy application source (changes frequently)

Changing application code does not invalidate the dependency installation layer.

### Runtime Configuration

The container sets `PYTHONPATH=/app/src` so the Python module loader can resolve `import api.main` correctly. The entry point `python -m api.main` executes the module as a script, which FastAPI's uvicorn server handles internally.

Environment variables can be overridden at runtime via Docker Compose or Kubernetes manifests. The Dockerfile provides sensible defaults (`HOST=0.0.0.0`, `PORT=8000`) that work in containerized environments.
