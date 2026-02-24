# Local Service Orchestration (Docker Compose)

Docker Compose orchestrates API and Web services on a single network, enabling inter-service communication testing before Kubernetes deployment. It validates container builds, service networking, and health checks.

???+ tip "Hands-on Guide"
    For step-by-step instructions, see [Layer 2: Docker Compose](local-development/layer-2-docker-compose.md) in the Local Development section.

## Architecture

Containers discover each other by service name on the Docker Compose bridge network:

```mermaid
flowchart LR
    subgraph compose[\"Docker Compose Network\"]
        Web[\"Web<br/>(:4321)\"]
        API[\"API<br/>(:8000)\"]
        Web -->|http://api:8000| API
    end
    Host[\"Host Browser\"] -->|localhost:4321| Web
    Host -->|localhost:8000| API
```

## Services & Access Reference

| Service | Container Port | Host Port | Container Access | Host Access |
|---------|----------------|-----------|-------------------|------------|
| API | 8000 | 8000 | `http://api:8000` | `http://localhost:8000/health` |
| Web | 4321 | 4321 | `http://web:4321` | `http://localhost:4321` |

**Key difference**: Between containers, use service names + container ports. From host, use localhost + host ports.

## Configuration

The `docker-compose.yml` specifies services, build arguments, health checks, and dependencies.

### Build Arguments

Web service requires `PUBLIC_API_URL` at build time:

```yaml
web:
  build:
    args:
      PUBLIC_API_URL: http://api:8000  # Container-to-container address
```

Why? Astro/Vite compiles `PUBLIC_*` variables into JavaScript at build time. For details and how to change this value, see [Environment Variables Guide](local-development/environment-variables-guide.md#public_api_url).

### Health Checks & Startup Order

???+ info "Startup Dependencies"
    API starts → API health check passes → Web starts → Web health check passes.

    This prevents the web service from calling the API before it's ready.

Health checks validate service readiness:

**API** (checks `/health` endpoint):

```yaml
healthcheck:
  test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"]
  interval: 10s
  timeout: 5s
  retries: 3
```

**Web** (checks if server is responding):

```yaml
healthcheck:
  test: ["CMD", "wget", "--quiet", "--spider", "http://localhost:4321"]
  interval: 10s
  timeout: 5s
  retries: 3
```

### Restart Policy

Services use `restart: unless-stopped`-automatically restart on crash, but not on explicit stop.

## Common Commands

| Command | What It Does |
|---------|--------------|
| `docker compose up -d` | Start all services (builds if needed) |
| `docker compose ps` | Show status and health checks |
| `docker compose logs -f api` | Stream API logs; use `web` for web |
| `docker compose build web` | Rebuild web service (after code changes) |
| `docker compose up -d --build` | Rebuild and restart all services |
| `docker compose down` | Stop and remove containers |

## Testing & Verification

After starting the stack:

1. **API health check**: `curl http://localhost:8000/health`
2. **Web loads**: Open `http://localhost:4321` in browser
3. **Services communicate**: Visit `/status` page-should show "Backend is healthy"
4. **Health status**: `docker compose ps` shows all containers healthy

???+ warning "Rebuilding Web"
    Changes to `PUBLIC_API_URL` or Astro source code require rebuild: `docker compose build web && docker compose up -d web`. See [Environment Variables Guide](local-development/environment-variables-guide.md) for details.

## Comparison with Kubernetes

| Contract | Docker Compose | Kubernetes |
|----------|----------------|------------|
| Images | Built locally | Built and pushed to registry |
| Health checks | HTTP/command-based | Liveness/readiness probes |
| Networking | Bridge network DNS | CoreDNS with namespaces |
| Resource limits | Optional | Enforced via Pod spec |

See [Local Kubernetes Architecture](local-kubernetes.md) for kind-based deployment.

## See Also

- [Layer 2: Docker Compose](local-development/layer-2-docker-compose.md) - Hands-on walkthrough
- [Environment Variables Guide](local-development/environment-variables-guide.md) - Configure variables by layer
- [Local Kubernetes Architecture](local-kubernetes.md) - kind cluster setup
- [API Service](../services/api.md)
- [Web Service](../services/web.md)
