# Layer 3: Kubernetes with kind

This layer deploys the platform services to a local Kubernetes cluster using [kind](https://kind.sigs.k8s.io/) (Kubernetes in Docker). This provides a production-like environment for testing GitOps workflows, namespace isolation, and Kubernetes-native service discovery.

## Prerequisites

- Docker running and accessible
- `kind` CLI installed ([installation guide](https://kind.sigs.k8s.io/docs/user/quick-start/#installation))
- `kubectl` CLI installed ([installation guide](https://kubernetes.io/docs/tasks/tools/))
- Completed [Layer 1: Docker Images](layer-1-docker-images.md) (understand image building)
- Completed [Layer 2: Docker Compose](layer-2-docker-compose.md) (understand service composition)

## Quick Start

For first-time setup or a complete end-to-end deployment, use the full workflow script:

```bash
mise kind-full
```

This single command will:

1. Create the kind cluster (if it doesn't exist)
2. Build both Docker images with correct tags and build arguments
3. Load images into the kind cluster
4. Deploy all manifests via kubectl
5. Wait for pods to be ready
6. Display access instructions

After running this command, your services will be ready to test via port-forwarding:

```bash
# Access API
kubectl port-forward --address 0.0.0.0 -n platform-api svc/api 8000:8000
curl http://localhost:8000/health

# Access Web (in another terminal)
kubectl port-forward --address 0.0.0.0 -n platform-web svc/web 4321:4321
curl http://localhost:4321/
```

**For iterative development**, see the [Iterative Development Workflow](#iterative-development-workflow) section below for faster rebuild commands.

**To understand each step in detail**, continue reading the [Deployment Workflow](#deployment-workflow) section.

## Architecture Differences from Docker Compose

| Aspect | Docker Compose | Kubernetes (kind) |
|--------|----------------|-------------------|
| **Networking** | Single bridge network | Namespace isolation with ClusterIP services |
| **Service Discovery** | `http://api:8000` | `http://api.platform-api:8000` (FQDN) |
| **Image Management** | Builds and uses immediately | Must build, tag, and load into cluster |
| **Health Checks** | Docker health checks | Liveness and readiness probes |
| **Configuration** | Environment variables in compose file | ConfigMaps referenced by pods |

## Deployment Workflow

### Step 1: Create the kind Cluster

Create a local Kubernetes cluster with deterministic networking configured for devcontainer compatibility:

```bash
./scripts/create-kind-cluster.sh
```

This script:

- Creates a kind cluster with port 6443 exposed
- Patches kubeconfig to use `host.docker.internal:6443`
- Sets TLS server name override to `localhost`
- Verifies cluster connectivity

**Verify cluster is ready:**

```bash
kubectl get nodes
```

Expected output:

```sh
NAME                 STATUS   ROLE           AGE   VERSION
kind-control-plane   Ready    control-plane  30s   v1.31.0
```

### Step 2: Build Docker Images

Build both service images with the correct tags for Kubernetes deployment.

**Build API image:**

```bash
docker build -t platform-api:latest -f services/api/Dockerfile services/api/
```

**Build Web image with cross-namespace API URL:**

```bash
docker build -t platform-web:latest \
  --build-arg PUBLIC_API_URL=http://api.platform-api:8000 \
  services/web/
```

> **Important:** The web service uses Astro, which bakes the `PUBLIC_API_URL` into the static build at build time. The URL **must** use the cross-namespace format (`http://api.platform-api:8000`) because the services are deployed in separate namespaces.

**Verify images were built:**

```bash
docker images | grep platform
```

Expected output:

```sh
platform-web    latest    <image-id>   <timestamp>   <size>
platform-api    latest    <image-id>   <timestamp>   <size>
```

### Step 3: Load Images into kind

kind runs Kubernetes inside Docker containers, so images must be explicitly loaded:

```bash
kind load docker-image platform-api:latest
kind load docker-image platform-web:latest
```

**Verify images are loaded in the cluster:**

```bash
docker exec -it kind-control-plane crictl images | grep platform
```

### Step 4: Deploy Manifests

Deploy both services using Kustomize:

```bash
kubectl apply -k gitops/apps/local/
```

This creates:

- Namespaces: `platform-api` and `platform-web`
- ConfigMaps: `api-config` and `web-config`
- Deployments: `api` and `web` (1 replica each)
- Services: `api` and `web` (ClusterIP)

**Monitor deployment progress:**

```bash
# Watch all pods
kubectl get pods --all-namespaces -w

# Or watch specific namespaces
kubectl get pods -n platform-api -w
kubectl get pods -n platform-web -w
```

### Step 5: Verify Deployment

**Check pod status:**

```bash
kubectl get pods -n platform-api
kubectl get pods -n platform-web
```

Expected output (both pods should be `Running` with `1/1` ready):

```sh
NAME                   READY   STATUS    RESTARTS   AGE
api-<hash>             1/1     Running   0          30s
```

**Check health probes:**

```bash
# View API pod details
kubectl describe pod -n platform-api -l app=api | grep -A10 "Liveness:\|Readiness:"

# View Web pod details
kubectl describe pod -n platform-web -l app=web | grep -A10 "Liveness:\|Readiness:"
```

**View pod logs:**

```bash
# API logs
kubectl logs -n platform-api -l app=api --tail=100 -f

# Web logs
kubectl logs -n platform-web -l app=web --tail=100 -f
```

### Step 6: Test Service Connectivity

Since services use ClusterIP (internal only), use port-forwarding to access them:

**Access API service:**

```bash
# In terminal 1
kubectl port-forward -n platform-api svc/api 8000:8000

# In terminal 2
curl http://localhost:8000/health
curl http://localhost:8000/info
```

Expected API response:

```json
{"status": "healthy"}
```

**Access Web service:**

```bash
# In terminal 1
kubectl port-forward -n platform-web svc/web 4321:4321

# In terminal 2 (or open browser to http://localhost:4321)
curl http://localhost:4321/
```

## Iterative Development Workflow

After initial setup with `mise kind-full`, you'll often need to test code changes quickly. This section covers fast iteration workflows.

### When to Use Each Workflow

| Scenario | Command | What It Does |
|----------|---------|-------------|
| **API code changes** | `mise kind-rebuild-api` | Rebuild API image → Load into kind → Restart deployment |
| **Web code changes** | `mise kind-rebuild-web` | Rebuild Web image → Load into kind → Restart deployment |
| **Manifest updates** | `kubectl apply -k gitops/apps/local/` | Apply updated Kubernetes manifests |
| **View API logs** | `kubectl logs -n platform-api -l app=api -f` | Follow API pod logs in real-time |
| **View Web logs** | `kubectl logs -n platform-web -l app=web -f` | Follow Web pod logs in real-time |
| **Complete rebuild** | `mise kind-full` | Full workflow from scratch |

### Quick Rebuild: API Service

When you've modified API code (`services/api/src/**`):

```bash
mise kind-rebuild-api
```

This command:

1. Builds `platform-api:latest` from `services/api/`
2. Loads the new image into kind cluster
3. Restarts the API deployment to use the new image

**Verify the update:**

```bash
# Check pod restart time (should be recent)
kubectl get pods -n platform-api

# View logs to confirm new code is running
kubectl logs -n platform-api -l app=api --tail=100 -f

# Test the API
kubectl port-forward --address 0.0.0.0 -n platform-api svc/api 8000:8000
curl http://localhost:8000/health
```

### Quick Rebuild: Web Service

When you've modified Web code (`services/web/src/**`):

```bash
mise kind-rebuild-web
```

This command:

1. Builds `platform-web:latest` with `PUBLIC_API_URL=http://api.platform-api:8000`
2. Loads the new image into kind cluster
3. Restarts the Web deployment to use the new image

> **Note:** The Web service uses Astro, which bakes environment variables at build time. If you need to change the API URL, you must rebuild the Web image.

**Verify the update:**

```bash
# Check pod restart time
kubectl get pods -n platform-web

# View logs
kubectl logs -n platform-web -l app=web --tail=100 -f

# Test the Web service
kubectl port-forward --address 0.0.0.0 -n platform-web svc/web 4321:4321
curl http://localhost:4321/
```

### Updating Manifests Only

If you've modified Kubernetes manifests (`gitops/apps/local/**/*.yaml`) without changing code:

```bash
kubectl apply -k gitops/apps/local/
```

Examples of manifest-only changes:

- Updating ConfigMaps (environment variables)
- Changing replica counts
- Modifying resource limits
- Adjusting health probe settings

**Monitor the update:**

```bash
# Watch rollout status
kubectl rollout status deployment/api -n platform-api
kubectl rollout status deployment/web -n platform-web

# View updated configuration
kubectl describe deployment api -n platform-api
```

### Debugging with Logs

View real-time logs from your services:

```bash
# Follow API logs
kubectl logs -n platform-api -l app=api --tail=100 -f

# Follow Web logs
kubectl logs -n platform-web -l app=web --tail=100 -f
```

These commands stream logs continuously (press Ctrl+C to exit).

**Advanced log viewing:**

```bash
# Last 50 lines only (without following)
kubectl logs -n platform-api -l app=api --tail=50

# Logs from previous container (if pod crashed and restarted)
kubectl logs -n platform-api -l app=api --previous

# Logs from all pods with timestamp
kubectl logs -n platform-api -l app=api --timestamps=true
```

### Development Loop Comparison

**kind vs Docker Compose for development:**

| Aspect | Docker Compose | kind (Kubernetes) |
|--------|----------------|-------------------|
| **Setup Time** | Fast (~10s) | Medium (~60s first time) |
| **Rebuild Time** | Fast (5-10s) | Medium (10-20s with image load) |
| **Production Parity** | Low | High |
| **Networking Complexity** | Simple | Realistic (namespaces, FQDN) |
| **Best For** | Quick feature development | Testing production manifests, GitOps workflows |

**Recommendation:**

- **Use Docker Compose** (Layer 2) for rapid feature development and debugging
- **Use kind** (Layer 3) for testing Kubernetes manifests, validating cross-namespace communication, and GitOps workflows

### Common Development Workflows

**1. Feature development (API focused):**

```bash
# Start with Docker Compose for fast iteration
docker compose up --build

# Make and test changes quickly...

# Once feature works, test in kind
mise kind-rebuild-api
kubectl port-forward -n platform-api svc/api 8000:8000
curl http://localhost:8000/your-new-endpoint
```

**2. Manifest updates:**

```bash
# Edit manifests in gitops/apps/local/
vim gitops/apps/local/api/deployment.yaml

# Apply and verify
kubectl apply -k gitops/apps/local/
kubectl get pods -n platform-api -w
```

**3. Full integration testing:**

```bash
# After significant changes, run full workflow
mise kind-full

# Test cross-service communication
kubectl port-forward -n platform-web svc/web 4321:4321
# Visit http://localhost:4321 and verify API calls work
```

## Manifest Files Structure

The GitOps manifests are organized in `gitops/apps/local/`:

```textsh
gitops/apps/local/
├── kustomization.yaml          # Root kustomization
├── api/
│   ├── kustomization.yaml      # API resources bundle
│   ├── namespace.yaml          # platform-api namespace
│   ├── configmap.yaml          # Environment variables
│   ├── deployment.yaml         # API deployment with health probes
│   └── service.yaml            # ClusterIP service on port 8000
└── web/
    ├── kustomization.yaml      # Web resources bundle
    ├── namespace.yaml          # platform-web namespace
    ├── configmap.yaml          # Environment variables + API URL
    ├── deployment.yaml         # Web deployment with health probes
    └── service.yaml            # ClusterIP service on port 4321
```

## Key Manifest Features

### Image Pull Policy

Both deployments use `imagePullPolicy: Never`:

```yaml
imagePullPolicy: Never
```

This tells Kubernetes to **only** use images present in the node's local cache. If the image isn't loaded via `kind load docker-image`, the pod will fail with `ImagePullBackOff`.

### Health Probes

**API Service** - Uses `/health` endpoint:

```yaml
livenessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 10
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /health
    port: http
  initialDelaySeconds: 5
  periodSeconds: 5
  failureThreshold: 3
```

**Web Service** - Uses `/` endpoint:

```yaml
livenessProbe:
  httpGet:
    path: /
    port: http
  initialDelaySeconds: 15
  periodSeconds: 10
  failureThreshold: 3

readinessProbe:
  httpGet:
    path: /
    port: http
  initialDelaySeconds: 10
  periodSeconds: 5
  failureThreshold: 3
```

### Cross-Namespace Service Discovery

The web service communicates with the API using the fully qualified domain name (FQDN):

```yaml
# gitops/apps/local/web/configmap.yaml
PUBLIC_API_URL: "http://api.platform-api:8000"
```

Format: `http://<service-name>.<namespace>:<port>`

## Troubleshooting

### Pods Stuck in ImagePullBackOff

**Symptom:**

```bash
kubectl get pods -n platform-api
NAME           READY   STATUS             RESTARTS   AGE
api-<hash>     0/1     ImagePullBackOff   0          30s
```

**Cause:** Image not loaded into kind cluster.

**Solution:**

```bash
# Verify image exists locally
docker images | grep platform-api

# Load image into kind
kind load docker-image platform-api:latest

# Restart deployment
kubectl rollout restart deployment/api -n platform-api
```

### Pods Stuck in CrashLoopBackOff

**Symptom:**

```bash
kubectl get pods -n platform-api
NAME           READY   STATUS             RESTARTS   AGE
api-<hash>     0/1     CrashLoopBackOff   5          2m
```

**Cause:** Application failing to start or health probe failing.

**Solution:**

```bash
# Check logs for errors
kubectl logs -n platform-api -l app=api --tail=100

# Check events
kubectl describe pod -n platform-api -l app=api

# Common fixes:
# 1. Port mismatch: Ensure container listens on the correct port
# 2. Missing dependencies: Image might be missing required files
# 3. Environment variables: Check ConfigMap values
```

### Liveness/Readiness Probe Failures

**Symptom:** Pods show `0/1` ready even when running.

**Solution:**

```bash
# Check probe configuration
kubectl describe pod -n platform-api -l app=api | grep -A5 "Liveness:\|Readiness:"

# Test endpoint manually
kubectl port-forward -n platform-api svc/api 8000:8000
curl http://localhost:8000/health  # Should return 200 OK

# If endpoint is wrong, update deployment.yaml probe paths
```

### Web Service Can't Reach API

**Symptom:** Web logs show connection errors to API.

**Cause:** Incorrect `PUBLIC_API_URL` at build time.

**Solution:**

```bash
# Rebuild web image with correct URL
docker build -t platform-web:latest \
  --build-arg PUBLIC_API_URL=http://api.platform-api:8000 \
  services/web/

# Reload and restart
kind load docker-image platform-web:latest
kubectl rollout restart deployment/web -n platform-web

# Verify ConfigMap has correct value
kubectl get configmap -n platform-web web-config -o yaml | grep PUBLIC_API_URL
```

### Can't Connect to kind Cluster

**Symptom:**

```bash
kubectl get nodes
The connection to the server localhost:6443 was refused
```

**Solutions:**

```bash
# 1. Verify cluster is running
kind get clusters
docker ps | grep kind

# 2. Recreate cluster
./scripts/delete-kind-cluster.sh
./scripts/create-kind-cluster.sh

# 3. Check kubeconfig context
kubectl config get-contexts
kubectl config use-context kind-kind
```

## Cleanup

### Delete Deployments (Keep Cluster)

```bash
kubectl delete -k gitops/apps/local/
```

### Delete Cluster

```bash
./scripts/delete-kind-cluster.sh
```

### Remove Images

```bash
docker rmi platform-api:latest platform-web:latest
```

## Next Steps

- **GitOps with ArgoCD**: Deploy Argo CD to automate manifest synchronization
- **Ingress Controller**: Add an Ingress to expose services externally
- **Persistent Storage**: Configure PersistentVolumes for stateful services
- **Multi-Environment**: Create `gitops/apps/dev/` and `gitops/apps/prod/` overlays
- **CI/CD Integration**: Automate image builds and deployments in pipelines

## Related Documentation

- [Layer 0: Local Execution](layer-0-local-execution.md)
- [Layer 1: Docker Images](layer-1-docker-images.md)
- [Layer 2: Docker Compose](layer-2-docker-compose.md)
- [Local Kubernetes Setup](../local-kubernetes.md)
- [Environment Variables Guide](environment-variables-guide.md)
