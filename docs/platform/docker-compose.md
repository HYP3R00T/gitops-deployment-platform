# Local Service Orchestration (Docker Compose)

Docker Compose provides a lightweight alternative to Kubernetes for local development and testing. It orchestrates both services (API and Web) on a single network, enabling validation of inter-service communication before deploying to Kubernetes.

## Purpose

- **Test service communication**: Verify API and Web can reach each other using service names
- **Validate container builds**: Ensure Dockerfiles produce working images
- **Debug networking**: Isolate network issues from Kubernetes complexity
- **Rapid iteration**: Faster startup than kind cluster provisioning

This is not a replacement for the Kubernetes-based deployment flow. It serves as a **pre-flight check** before promoting images to the GitOps pipeline.

???+ tip "Hands-on Guide"
    For step-by-step instructions on using Docker Compose in your local workflow, see [Layer 2: Docker Compose](local-development/layer-2-docker-compose.md) in the Local Development section.

## Architecture

Docker Compose creates an isolated bridge network where containers discover each other by service name.

```mermaid
flowchart LR
    subgraph compose[\"Docker Compose Network\"]
        Web[\"Web Container<br/>(service name: 'web')<br/>listens on :4321\"]
        API[\"API Container<br/>(service name: 'api')<br/>listens on :8000\"]
        Web -->|http://api:8000| API
    end

    Host[\"Host Browser<br/>(devcontainer)<br/>accessing services\"] -->|mapped to<br/>localhost:4321| Web
    Host -->|mapped to<br/>localhost:8000| API
```

**Key insight**: Containers communicate using service names and container ports. Host access uses port mappings.

| Context | Connection | URL |
|---------|-----------|-----|
| Web → API (container-to-container) | Service discovery | `http://api:8000` |
| Browser → Web | Port mapping | `http://localhost:4321` |
| Browser → API | Port mapping | `http://localhost:8000` |

## Configuration

The compose specification lives at `docker-compose.yml` in the repository root.

### Services

**api** service:

- Listens on container port `8000` (inside the container)
- Mapped to host port `8000` (for browser access: `localhost:8000`)
- Reachable by other containers as `http://api:8000`

**web** service:

- Listens on container port `4321`
- Mapped to host port `4321`
- Reaches the API via `http://api:8000` (uses service name discovery)

### Build Arguments

The web service requires `PUBLIC_API_URL` as a **build argument**:

```yaml
web:
  build:
    args:
      PUBLIC_API_URL: http://api:8000  # Using container-to-container address
```

Why? Astro/Vite compiles `PUBLIC_*` environment variables into the JavaScript bundle at **build time**. The web service needs the container-to-container address (`http://api:8000`), not the host port mapping.

???+ info "Container-to-container always uses container ports"
	When one container connects to another, it uses the service name and the **port inside the container**, never the host port mapping. This is true for all container orchestration systems (Docker Compose, Kubernetes, etc.).

### Health Checks and Dependencies

The web service declares `depends_on` with `condition: service_healthy`, ensuring startup order:

1. API container starts
2. API health check runs every 10s (up to 3 retries)
3. Once API reports healthy, web container starts
4. Web health check validates the web server is responding

This prevents race conditions where the web service attempts API calls before the API is ready.

### Health Check Implementation

**API Service Health Check:**

```yaml
healthcheck:
  test: ["CMD", "python", "-c", "import urllib.request; urllib.request.urlopen('http://localhost:8000/health')"]
  interval: 10s
  timeout: 5s
  retries: 3
  start_period: 10s
```

Uses Python's `urllib.request` to call the `/health` endpoint. This method:

- Requires no additional CLI tools inside the container
- Handles HTTP content validation automatically
- Is idiomatic for Python applications

**Web Service Health Check:**

```yaml
healthcheck:
  test: ["CMD", "wget", "--quiet", "--tries=2", "--spider", "http://localhost:4321"]
  interval: 10s
  timeout: 5s
  retries: 3
  start_period: 5s
```

Uses `wget --spider` to perform a HEAD-like request. This method:

- Checks only that the server is responding (doesn't validate response content)
- Starts faster than the API check (5s vs 10s start period)
- Works for any HTTP server regardless of tech stack

### Container Names

Each service is assigned a predictable container name for easy reference:

```yaml
api:
  container_name: api
web:
  container_name: web
```

These names enable easy management:

```bash
# Stop only the API
docker stop api

# View logs for a specific container
docker logs web

# Execute a command in the API container
docker exec -it api python -c "import sys; print(sys.version)"
```

### Restart Policy

Both services use `restart: unless-stopped`, which automatically restarts containers if they exit unexpectedly:

```yaml
restart: unless-stopped
```

This policy:

- **Restarts** if the container crashes (exit code != 0)
- **Restarts** if Docker daemon restarts
- **Does NOT restart** if you explicitly stop the container (`docker compose down`)
- **Does NOT restart** if the exit was due to `docker stop`

Alternative policies:

- `no` — no automatic restart
- `always` — restart even if you explicitly stopped it
- `on-failure` — restart only on non-zero exit codes
- `unless-stopped` — restart except on explicit stop (recommended for development)

## Common Operations

### Start Services

```bash
docker compose up -d
```

Both services build (if needed) and start in detached mode. API must pass health checks before web starts.

### View Logs

```bash
# Follow all logs
docker compose logs -f

# View specific service
docker compose logs -f web
docker compose logs -f api
```

### Check Status

```bash
docker compose ps
```

Shows container state, ports, and health status.

### Rebuild After Code Changes

```bash
# Rebuild specific service
docker compose build web

# Rebuild and restart
docker compose up -d --build
```

???+ warning "Web service rebuilds"
    Any change to `PUBLIC_API_URL` or Astro source files requires rebuilding the web service. Runtime environment variables do not affect the compiled JavaScript bundle.

### Stop and Remove

```bash
# Stop containers (keeps images and network)
docker compose down

# Stop and remove volumes (if any were defined)
docker compose down -v
```

## Accessing Services

### From Your Browser (Host Machine)

Port forwarding through the devcontainer enables access:

- **Web interface**: `http://localhost:4321`
- **API health endpoint**: `http://localhost:8000/health`
- **Web status page**: `http://localhost:4321/status` (shows API connectivity)

If ports are not forwarding, ensure `.devcontainer/devcontainer.json` includes:

```json
"forwardPorts": [8001, 4321]
```

### Between Containers (Internal)

Containers reach each other by service name using container ports:

- **Web → API**: `http://api:8000` (web's DEFAULT in Dockerfile)
- **API → Web**: `http://web:4321` (if needed)

These internal addresses are set at **build time** (via build args) and **runtime** (via environment variables). Host port mappings (4321) are irrelevant to containers.

## Verification Checklist

After starting the stack:

1. **API responds** (host port): `curl http://localhost:8000/health`
2. **Web loads** (host port): Open `http://localhost:4321` in browser
3. **Services communicate** (internal): Visit `http://localhost:4321/status` and confirm "Backend is healthy"
4. **Both are healthy**: `docker compose ps` shows both as `(healthy)`

???+ tip "Troubleshooting 'Backend is unavailable'"
	If the status page shows "Backend is unavailable" but `localhost:8001/health` works:

	- The web image was built with the wrong `PUBLIC_API_URL`
	- Rebuild: `docker compose build web && docker compose up -d web`

## Comparison with Kubernetes

Docker Compose validates the same contracts enforced by Kubernetes:

| Contract | Docker Compose | Kubernetes |
|----------|----------------|------------|
| Container images | Built locally, tagged `latest` | Built and pushed to registry |
| Health checks | HTTP/command-based | Liveness/readiness probes |
| Service networking | Bridge network DNS | CoreDNS with namespace isolation |
| Resource limits | Optional (not enforced by default) | Requests and limits in Pod spec |

The Kubernetes manifests in `gitops/apps/local/` define the same services with stricter resource constraints and cross-namespace networking. See [Local Kubernetes Architecture](local-kubernetes.md) for the kind-based deployment flow.

## See Also

- [API Service](../services/api.md) - API endpoints and container build
- [Web Service](../services/web.md) - Frontend pages and Astro build process
- [Local Kubernetes Architecture](local-kubernetes.md) - kind cluster setup for GitOps testing
- [Developer Setup](../dev/developer-setup.md) - Devcontainer and tooling configuration
