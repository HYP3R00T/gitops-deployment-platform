# Environment Variables Across Layers

Quick reference for which variables can be edited at each layer and how.

???+ info "Why Build-Time Locking Exists"
    Astro/Vite compiles `PUBLIC_*` variables into JavaScript at build time-they're not available at runtime. This is intentional: smaller bundle, no secret leaks. Trade-off: rebuild needed to change `PUBLIC_API_URL`. Other variables (`LOG_LEVEL`, `HOST`, `PORT`) are runtime and can change without rebuilding.

## Quick Decision Table

| Variable | Layer 0 | Layer 1 | Layer 2 | Layer 3 | Changeable | How |
|----------|---------|---------|---------|---------|-----------|-----|
| `PUBLIC_API_URL` | ✅ Runtime | ❌ Build-time | ❌ Build-time | ✅ Runtime env | Need rebuild (L1-2) | `--build-arg` for layers 1-2; k8s env for layer 3 |
| `LOG_LEVEL` | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes | Change anytime | Environment variable; restart to apply |
| `HOST` | ✅ Yes | ✅ Yes (env) | ✅ Yes (service name) | ✅ Yes | Change anytime | Override in config; restart |
| `PORT` | ✅ Yes | ⚠️ Port map | ⚠️ Port map | ✅ Yes (service port) | Rarely | Edit docker-compose.yml or Kubernetes manifest |

## PUBLIC_API_URL

Tells the Web service where to find the API.

**Layers 0 & Dev Server** (can change at runtime):

```bash
PUBLIC_API_URL=http://localhost:8000 pnpm --dir services/web dev
```

**Layers 1 & 2** (locked at build time-must rebuild to change):

```bash
# During build
docker build --build-arg PUBLIC_API_URL=http://api:8000 ...

# In docker-compose.yml
web:
  build:
    args:
      PUBLIC_API_URL: http://api:8000
```

**Why this difference?** Layer 0 uses Astro dev server (reloads on change). Layers 1-2 bake the value into the bundle at build time. For container-to-container communication, use `http://api:8000` (service name). For host access, use `http://localhost:8000`.

For step-by-step rebuild examples, see [Layer 1 Manual Walkthrough](layer-1-docker-images.md#manual-approach) or [Layer 2 Rebuild Section](layer-2-docker-compose.md#rebuilding-after-changes).

## LOG_LEVEL

Controls logging verbosity. Options: `debug`, `info`, `warning`, `error`.

**Layer 0** (direct):

```bash
LOG_LEVEL=debug uv run api
```

**Layers 1 & 2** (Docker):

```bash
docker run -e LOG_LEVEL=debug api:latest

# or in docker-compose.yml
api:
  environment:
    - LOG_LEVEL=debug
```

**Layer 3** (Kubernetes): Set in k8s ConfigMap or env field. Change takes effect on pod restart.

**Can change anytime without rebuild.** Just apply and restart the service.

## HOST

IP address the service binds to. `0.0.0.0` = all interfaces (default). `127.0.0.1` = localhost only.

**Layer 0**:

```bash
HOST=0.0.0.0 uv run api
```

**Layers 1, 2, 3**: Set via environment variable or service config. Override at runtime-no rebuild needed.

## PORT

Service port inside the container (not the host port exposed).

**Layer 0**: Change via environment or script flag.

**Layers 1 & 2**: Port mapping in `docker run` or `docker-compose.yml`. Host port may differ from container port:

```bash
docker run -p 9000:8000 api:latest  # Host 9000 → Container 8000
```

**Layer 3**: Service port in Kubernetes manifest.

---

## When to Edit What

| Scenario | Action |
|----------|--------|
| **Quick API iteration** | Layer 0: Direct `uv run api` |
| **Testing Docker build** | Layer 1-2: Build image locally |
| **Docker Compose testing** | Layer 2: Edit docker-compose.yml, restart |
| **Kubernetes testing** | Layer 3: Edit manifest, apply, redeploy |
| **Change PUBLIC_API_URL** | Layers 1-2 only: Rebuild with new `--build-arg` |
| **Change LOG_LEVEL, HOST, PORT** | Any layer: Set env var, restart (no rebuild) |

For Kubernetes-specific configuration, see [Layer 3 Documentation](layer-3-kubernetes-kind.md#configuration).

## See Also

- [Layer 1: Individual Docker Images](layer-1-docker-images.md) - Rebuild examples
- [Layer 2: Docker Compose](layer-2-docker-compose.md) - docker-compose.yml configuration
- [Layer 3: Kubernetes with kind](layer-3-kubernetes-kind.md) - Kubernetes deployment examples
- [API Service](../../services/api.md)
- [Web Service](../../services/web.md)
