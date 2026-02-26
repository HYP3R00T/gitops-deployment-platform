# Local Development: Layer-by-Layer Guide

This guide shows how the API and Web services communicate at each layer of development, from simplest (local execution) to production-like (orchestrated containers).

Each layer builds on the previous one, introducing new concepts and solving problems from the layer below.

## The Layers

### **Layer 0: Local Execution**

Both services run directly on your machine using native commands.

- **API**: `uv run api`
- **Web**: `pnpm dev`
- **Communication**: Direct `localhost` addresses
- **Isolation**: None (both services share your machine's network)
- **Best for**: Rapid iteration, debugging
- **Problems**: Not production-like, no containerization test

### **Layer 1: Individual Docker Images**

Each service builds into its own Docker image, then runs in separate containers. Two approaches available:

**Automated (Quick Start)**:

- `./scripts/docker-run-local.sh` builds, networks, and starts everything
- `./scripts/docker-stop-local.sh` cleans up
- Best for: Getting the system running immediately

**Manual (Learning)**:

- `docker build` and `docker run` for each service
- Create Docker network for container communication
- Best for: Understanding how each step works

**Common to both**:

- **Communication**: Docker network for container-to-container discovery
- **Best for**: Testing container builds, running services locally, understanding Docker
- **Next step**: Docker Compose (Layer 2) further automates orchestration

### **Layer 2: Docker Compose**

Docker Compose orchestrates both containers on a shared network.

- **Orchestration**: `docker compose up -d`
- **Communication**: Service names + container ports (`http://api:8000`)
- **Network**: Bridge network with automatic DNS
- **Health checks**: Dependency ordering
- **Best for**: Full local development, testing inter-service communication
- **Problems**: Single-machine only, no namespace isolation

### **Layer 3: Kubernetes with kind**

Kubernetes cluster running locally using kind (Kubernetes in Docker).

- **Orchestration**: `kubectl apply -k gitops/apps/local/`
- **Communication**: Cross-namespace FQDN (`http://api.platform-api:8000`)
- **Isolation**: Separate namespaces for each service
- **Health checks**: Liveness and readiness probes
- **Best for**: Production-like environment, testing GitOps workflows, namespace isolation
- **Problems**: More complex setup, requires image loading into cluster

### **Environment Variables Across Layers**

How `PUBLIC_API_URL` and other variables change at each layer.

- **Layer 0**: Set at runtime and can change immediately
- **Layer 1**: Problem containers isolated, needs build args
- **Layer 2**: Build args are baked into the image at build time
- **Decision table**: Which variables are editable and which are locked

---

## Quick Start by Layer

**Start at Layer 0 if:** You're new to the services and want to understand what they do.

**Jump to Layer 1 if:** You have working services locally and want to test Docker images.

**Skip to Layer 2 if:** You already understand Docker and want full orchestration.

**Jump to Layer 3 if:** You want a production-like Kubernetes environment and GitOps workflows.

**Read Environment Variables if:** You're debugging connectivity or build issues.

---

## The Problem Each Layer Solves

| Problem | Layer 0 | Layer 1 | Layer 2 | Layer 3 |
|---------|---------|---------|---------|----------|
| Services communication | Direct localhost | Service discovery | Service discovery | Cross-namespace FQDN |
| Production-like test | No | Partial | Yes | Yes (Kubernetes) |
| Repeatable setup | No | Yes (scripts or manual) | Yes (orchestrated) | Yes (GitOps) |
| Environment consistency | Local only | Image-based | Container-based | Kubernetes-native |
| Scale to multiple machines | No | No | No | Yes (in theory) |
| Namespace isolation | No | No | No | Yes |
| Health monitoring | No | Basic | Health checks | Probes + restarts |

---

## See Also

- [Layer 0: Local Execution](layer-0-local-execution.md)
- [Layer 1: Docker Images](layer-1-docker-images.md)
- [Layer 2: Docker Compose](layer-2-docker-compose.md)
- [Layer 3: Kubernetes with kind](layer-3-kubernetes-kind.md)
- [Environment Variables Guide](environment-variables-guide.md)
- [API Service](../../services/api.md) - Service endpoints and contracts
- [Web Service](../../services/web.md) - Frontend pages and communication
- [Local Kubernetes](../local-kubernetes.md) - Kind cluster setup details
