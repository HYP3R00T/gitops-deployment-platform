# Local Development: Layer-by-Layer Guide

This guide shows how the API and Web services communicate at each layer of development, from simplest (local execution) to production-like (orchestrated containers).

Each layer builds on the previous one, introducing new concepts and solving problems from the layer below.

## The Layers

### **Layer 0: Local Execution** [→](layer-0-local-execution.md)

Both services run directly on your machine using native commands.

- **API**: `uv run api`
- **Web**: `pnpm dev`
- **Communication**: Direct `localhost` addresses
- **Isolation**: None (both services share your machine's network)
- **Best for**: Rapid iteration, debugging
- **Problems**: Not production-like, no containerization test

### **Layer 1: Individual Docker Images** [→](layer-1-docker-images.md)

Each service builds into its own Docker image, then runs in separate containers.

- **Building**: `docker build` for each service
- **Running**: `docker run` for each service
- **Communication**: Problem—containers can't reach each other by default
- **Demonstration**: Why Docker Compose is needed
- **Best for**: Testing container builds, understanding Docker
- **Problems**: Manual network management, no service discovery

### **Layer 2: Docker Compose** [→](layer-2-docker-compose.md)

Docker Compose orchestrates both containers on a shared network.

- **Orchestration**: `docker compose up -d`
- **Communication**: Service names + container ports (`http://api:8000`)
- **Network**: Bridge network with automatic DNS
- **Health checks**: Dependency ordering
- **Best for**: Full local development, testing inter-service communication
- **Problems**: Single-machine only (Kubernetes solves this)

### **Environment Variables Across Layers** [→](environment-variables-guide.md)

How `PUBLIC_API_URL` and other variables change at each layer.

- **Layer 0**: Set at runtime → can change immediately
- **Layer 1**: Problem—containers isolated, needs build args
- **Layer 2**: Build args → baked into image at build time
- **Decision table**: Which variables are editable, which are locked

---

## Quick Start by Layer

**Start at Layer 0 if:** You're new to the services and want to understand what they do.

**Jump to Layer 1 if:** You have working services locally and want to test Docker images.

**Skip to Layer 2 if:** You already understand Docker and want full orchestration.

**Read Environment Variables if:** You're debugging connectivity or build issues.

---

## The Problem Each Layer Solves

| Problem | Layer 0 | Layer 1 | Layer 2 |
|---------|---------|---------|---------|
| Services communication | ✅ Direct localhost | ❌ Container isolation | ✅ Service discovery |
| Production-like test | ❌ No | ⚠️ Partial | ✅ Yes |
| Repeatable setup | ❌ No | ⚠️ Yes (manual) | ✅ Yes (automated) |
| Environment consistency | ❌ Local only | ⚠️ Image-based | ✅ Container-based |
| Scale to multiple machines | ❌ No | ❌ No | ❌ No (Kubernetes) |

---

## See Also

- [API Service](../../services/api.md) - Service endpoints and contracts
- [Web Service](../../services/web.md) - Frontend pages and communication
- [Local Kubernetes](../local-kubernetes.md) - Next step beyond Compose (Kubernetes)
