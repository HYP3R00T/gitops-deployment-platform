# API Service

Minimal stateless backend for GitOps demonstrations.

## Quick Start

```bash
uv sync
uv run api       # Starts on 0.0.0.0:8000
uv run pytest    # Run tests
```

## API Contract (v1)

Three endpoints. No more, no less.

| Endpoint | Response |
| -------- | -------- |
| `GET /` | `{"service": "gitops-deployment-platform", "status": "ok"}` |
| `GET /health` | `{"healthy": true}` (200 or 503) |
| `GET /info` | `{"name": "gitops-deployment-platform", "description": "Minimal backend for GitOps demonstrations", "environment": "static"}` |

## Design

- **Stateless** – No database, no persistence, resets on restart
- **Static responses** – No dynamic metadata, timestamps, or environment data
- **Kubernetes-native** – Health probes, resource limits, declarative config
- **Stable contract** – Expansion via new endpoints or `/v2`, never repurposing existing ones

## Kubernetes

Manifests in `kubernetes/` directory:

```bash
kubectl apply -k kubernetes/
```

Probes use `GET /health` with 10s/5s initial delay, 10s/5s period, 3 failure threshold.

## Implementation Status

✅ All endpoints implemented per v1 spec
✅ Kubernetes manifests (Deployment, Service, Ingress)
✅ All tests passing
✅ No metadata exposure
