# Environment Variables Across Layers

Reference guide for which environment variables can be edited at each layer, and how.

## Quick Decision Table

| Variable | Layer 0 | Layer 1 | Layer 2 | Where | Editable |
|----------|---------|---------|---------|-------|----------|
| `PUBLIC_API_URL` | ✅ Runtime | ⚠️ Build arg | ⚠️ Build arg | docker-compose.yml | Requires rebuild |
| `LOG_LEVEL` | ✅ Runtime | ✅ Runtime | ✅ Runtime | docker-compose.yml | Direct |
| `PORT` (API) | ⚠️ Build default | ⚠️ Build default | ⚠️ Build default | Dockerfile | Rarely change |
| `HOST` | ✅ Runtime | ✅ Env var | ✅ Env var | docker-compose.yml | Direct |

**Legend:**

- ✅ = Can change easily
- ⚠️ = Must rebuild
- ❌ = Cannot change

## PUBLIC_API_URL

**Purpose**: Tells Web service where the API is located.

### Layer 0: Local Execution

**How to set:**

```bash
PUBLIC_API_URL=http://localhost:8000 pnpm --dir services/web dev --host 0.0.0.0
```

**Value options:**

```bash
# Local API
PUBLIC_API_URL=http://localhost:8000

# Custom port (if running API on different port)
PUBLIC_API_URL=http://localhost:9000

# Remote API
PUBLIC_API_URL=https://api.example.com:443

# Using different host
PUBLIC_API_URL=http://192.168.1.100:8000
```

**Can change immediately**: ✅ Yes

- Web dev server reloads when you change it
- No rebuild needed

### Layer 1: Individual Docker Images

**Problem**: Value is baked into the Docker image at **build time** by Astro/Vite.

**How to set (at build time):**

```bash
docker build \
  -t web:latest \
  -f services/web/Dockerfile \
  --build-arg PUBLIC_API_URL=http://api:8000 \
  .
```

**Can change immediately**: ❌ No

- Must rebuild the image
- Runtime environment variable won't work

**Value options (at build time):**

```bash
# Container-to-container (use this value for Layer 1!)
--build-arg PUBLIC_API_URL=http://api:8000

# Host access (if testing from outside Docker)
--build-arg PUBLIC_API_URL=http://localhost:8000

# Remote API
--build-arg PUBLIC_API_URL=https://api.example.com
```

**If you need to change it:**

```bash
# Rebuild with new value
docker build \
  -t web:latest \
  -f services/web/Dockerfile \
  --build-arg PUBLIC_API_URL=http://api:9000 \
  .

# Stop and remove old container
docker stop web-container
docker rm web-container

# Run new container
docker run -d --name web-container -p 4321:4321 web:latest
```

### Layer 2: Docker Compose

**How to set (in docker-compose.yml):**

```yaml
web:
  build:
    context: .
    dockerfile: services/web/Dockerfile
    args:
      PUBLIC_API_URL: http://api:8000  # ← Set here
```

**Can change immediately**: ❌ No

- Must rebuild the image
- Then restart the container

**If you need to change it:**

```yaml
# Edit docker-compose.yml
web:
  build:
    args:
      PUBLIC_API_URL: http://api:9000  # ← Change to new value
```

Then rebuild and restart:

```bash
docker compose build web
docker compose up -d web
```

## LOG_LEVEL (API)

**Purpose**: Controls logging verbosity for the API service.

**Options**: `debug`, `info`, `warning`, `error`

### Layer 0: Local Execution

**How to set:**

```bash
LOG_LEVEL=debug uv run api
```

**Can change immediately**: ✅ Yes (restart API to see effect)

### Layer 1: Individual Docker Images

**How to set:**

```bash
docker run -d \
  --name api-container \
  -p 8000:8000 \
  -e LOG_LEVEL=debug \
  api:latest
```

**Can change immediately**: ✅ Yes (if you restart container)

**To change without rebuilding:**

```bash
# Stop current container
docker stop api-container

# Run with new log level
docker run -d \
  --name api-container \
  -p 8000:8000 \
  -e LOG_LEVEL=info \
  api:latest
```

### Layer 2: Docker Compose

**How to set (in docker-compose.yml):**

```yaml
api:
  environment:
    - LOG_LEVEL=info
```

**Can change immediately**: ✅ Yes (with restart)

**To change and apply:**

```bash
# Edit docker-compose.yml
# Change LOG_LEVEL value

# Restart API to apply
docker compose up -d api
```

## HOST (API and Web)

**Purpose**: IP address the service binds to.

- `0.0.0.0` = Listen on all interfaces (default, recommended)
- `127.0.0.1` = Listen on localhost only
- Specific IP = Listen on that specific interface

### Layer 0: Local Execution

**API:**

```bash
HOST=0.0.0.0 uv run api  # Accessible from other machines
HOST=127.0.0.1 uv run api  # Localhost only
```

**Web:**

```bash
pnpm --dir services/web dev --host 0.0.0.0
pnpm --dir services/web dev --host 127.0.0.1
```

### Layer 1 & 2: Docker Images

**API (in Dockerfile):**

```dockerfile
ENV HOST=0.0.0.0
```

**Can override at runtime:**

```bash
# Layer 1: Individual container
docker run -e HOST=127.0.0.1 api:latest

# Layer 2: Docker Compose
api:
  environment:
    - HOST=0.0.0.0
```

## PORT (API and Web)

**Purpose**: Port the service listens on inside the container.

### Layer 0: Local Execution

**API (default 8000):**

```bash
PORT=9000 uv run api  # API listens on 9000
```

**Web (default 4321):**

Already handled by Astro, change via `docker-compose.yml` if needed.

### Layer 1: Individual Docker Images

**You can override, but rarely needed:**

```bash
docker run -e PORT=9000 api:latest
```

**Port mapping** handles host exposure:

```bash
docker run -p 9000:8000 api:latest
# Host port 9000 → Container port 8000
```

### Layer 2: Docker Compose

**Port mapping (host:container):**

```yaml
api:
  ports:
    - "8001:8000"  # Access via localhost:8001
```

## Decision: When to Edit What

### Changing API behavior

- **Faster iteration**: Use Layer 0 (direct Python)
- **Testing Docker image**: Use Layer 1 or 2

### Changing Web behavior

- **Faster iteration**: Use Layer 0 (Astro dev server reloads)
- **Testing Docker image**: Use Layer 1 or 2

### Changing PUBLIC_API_URL

- **Layer 0**: Change and restart Web
- **Layer 1 & 2**: Rebuild required
    - This is why `docker compose.yml` values should reflect final deployment

### Changing LOG_LEVEL

- **All layers**: Change and restart (no rebuild needed)

### Changing PORT or HOST

- **Layer 0**: Change and restart
- **Layer 1**: Rebuild or use `-e` flag at runtime
- **Layer 2**: Edit `docker-compose.yml` and restart

## Architecture Decision: Why Some Variables Are Locked

**Astro/Vite Environment Variables:**

All `PUBLIC_*` environment variables are compiled into JavaScript at **build time**. This includes `PUBLIC_API_URL`.

- **Pros**: Smaller runtime footprint, no secret leaks
- **Cons**: Must rebuild to change

**Why it matters for your architecture:**

1. **Layer 0**: When developing, you change `PUBLIC_API_URL` and reload
2. **Layer 1**: When building for Docker, it's locked in the image
3. **Layer 2**: Docker Compose must specify the correct value for your network

This is why `docker-compose.yml` uses `public_API_URL: http://api:8000`—it's the correct container-to-container address.

## See Also

- [Layer 0: Local Execution](layer-0-local-execution.md)
- [Layer 1: Individual Docker Images](layer-1-docker-images.md)
- [Layer 2: Docker Compose](layer-2-docker-compose.md)
- [API Service](../../services/api.md)
- [Web Service](../../services/web.md)
