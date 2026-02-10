# API Service

Minimal stateless backend for GitOps demonstrations. It exposes a fixed v1 contract for health and metadata checks and keeps all state in memory.

## Purpose

- Provide deterministic responses for platform validation
- Serve as a probe target for deployment, failure, and recovery flows
- Keep behavior static and predictable across restarts

## Runtime

- Framework: FastAPI
- Entry point: `api.main:main`
- Default bind: `0.0.0.0:8000`

## Configuration

Configuration is intentionally minimal and loaded from environment using `utilityhub_config`. The only defined setting is:

| Setting | Type | Default | Description |
| --- | --- | --- | --- |
| `app_name` | string | `api` | Service name used in logs |

## API Contract

| Endpoint | Response | Notes |
| --- | --- | --- |
| `GET /` | `{"service": "gitops-deployment-platform", "status": "ok"}` | Static metadata |
| `GET /health` | `{"healthy": true}` | Returns 200 when healthy, 503 when unhealthy |
| `GET /info` | `{"name": "gitops-deployment-platform", "description": "Minimal backend for GitOps demonstrations", "environment": "static"}` | Static metadata |

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
