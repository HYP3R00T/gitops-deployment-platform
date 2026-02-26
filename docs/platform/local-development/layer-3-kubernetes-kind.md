# Layer 3: Kubernetes with kind

Deploy services to a local Kubernetes cluster using [kind](https://kind.sigs.k8s.io/) for production-like testing of GitOps workflows, namespace isolation, and service discovery.

## Quick Start

```bash
mise kind-full
```

This creates the cluster, builds images, loads them into kind, deploys manifests, and waits for pods to be ready. Then access services via port-forwarding:

```bash
# Terminal 1: API
kubectl port-forward -n platform-api svc/api 8000:8000
curl http://localhost:8000/health

# Terminal 2: Web
kubectl port-forward -n platform-web svc/web 4321:4321
curl http://localhost:4321/
```

For iterative development, see below. For step-by-step details, continue reading.

## Prerequisites

- Docker running
- `kind` and `kubectl` CLIs installed
- Completed [Layer 1](layer-1-docker-images.md) and [Layer 2](layer-2-docker-compose.md)

## Architecture vs Docker Compose

| Aspect | Docker Compose | Kubernetes (kind) |
|--------|---|---|
| Networking | Single bridge | Namespace isolation + ClusterIP |
| Service Discovery | `http://api:8000` | `http://api.platform-api:8000` (FQDN) |
| Image Management | Builds immediately | Build, tag, load into cluster |
| Health Checks | Docker checks | Liveness/readiness probes |
| Configuration | Environment in compose file | ConfigMaps |

## Deployment Workflow

**Step 1: Create cluster**

```bash
./scripts/create-kind-cluster.sh
kubectl get nodes  # Should show kind-control-plane Ready
```

**Step 2: Build images**

```bash
docker build -t platform-api:latest -f services/api/Dockerfile services/api/
docker build -t platform-web:latest --build-arg PUBLIC_API_URL=http://api.platform-api:8000 services/web/
```

**Step 3: Load into kind**

```bash
kind load docker-image platform-api:latest
kind load docker-image platform-web:latest
```

**Step 4: Deploy manifests**

```bash
kubectl apply -k gitops/apps/local/
```

Creates namespaces (`platform-api`, `platform-web`), ConfigMaps, Deployments, and Services.

**Step 5: Verify deployment**

```bash
kubectl get pods -n platform-api
kubectl get pods -n platform-web
```

Both should show `Running` and `1/1 Ready`.

**Step 6: Test connectivity**

```bash
kubectl port-forward -n platform-api svc/api 8000:8000
curl http://localhost:8000/health  # Should return {"status": "healthy"}
```

## Iterative Development

| Scenario | Command | Result |
|---|---|---|
| API code changes | `mise kind-rebuild-api` | Rebuild image, load, restart deployment |
| Web code changes | `mise kind-rebuild-web` | Rebuild image, load, restart deployment |
| Manifest updates | `kubectl apply -k gitops/apps/local/` | Apply updated k8s resources |
| View API logs | `kubectl logs -n platform-api -l app=api -f` | Stream logs in real-time |
| View Web logs | `kubectl logs -n platform-web -l app=web -f` | Stream logs in real-time |
| Full rebuild | `mise kind-full` | Complete workflow from scratch |

???+ tip "Docker Compose vs kind for Development"
    Use Docker Compose for rapid feature development (faster rebuild). Use kind when testing Kubernetes manifests, cross-namespace communication, or GitOps workflows.

## Manifest Structure

```sh
gitops/apps/local/
├── kustomization.yaml
├── api/
│   ├── namespace.yaml
│   ├── configmap.yaml (environment variables)
│   ├── deployment.yaml (with health probes)
│   └── service.yaml (ClusterIP :8000)
└── web/
    ├── namespace.yaml
    ├── configmap.yaml (PUBLIC_API_URL set here)
    ├── deployment.yaml (with health probes)
    └── service.yaml (ClusterIP :4321)
```

### Key Features

**Image Pull Policy**: Deployments use `imagePullPolicy: Never`-images must exist in kind's local cache.

**Health Probes**: Both services use HTTP GET for liveness and readiness checks on `/health` (API) or `/` (Web).

**Cross-Namespace Service Discovery**: Web calls API via FQDN (`http://api.platform-api:8000`). Format: `http://<service>.<namespace>:port`.

## Troubleshooting

???+ question "Pods in ImagePullBackOff?"
    Image not loaded into kind. Solution: `kind load docker-image platform-api:latest && kubectl rollout restart deployment/api -n platform-api`

???+ question "Pods in CrashLoopBackOff?"
    Application error on startup. Check logs: `kubectl logs -n platform-api -l app=api --tail=100`. Common causes: port mismatch, missing dependencies, wrong environment variables.

???+ question "Web can't reach API?"
    `PUBLIC_API_URL` incorrect at build time. Rebuild web with correct FQDN: `docker build -t platform-web:latest --build-arg PUBLIC_API_URL=http://api.platform-api:8000 services/web/ && kind load docker-image platform-web:latest && kubectl rollout restart deployment/web -n platform-web`

???+ question "Can't connect to kind cluster?"
    1. Check cluster running: `kind get clusters`
    2. Verify context: `kubectl config use-context kind-kind`
    3. Recreate if needed: `./scripts/delete-kind-cluster.sh && ./scripts/create-kind-cluster.sh`

???+ question "Liveness/readiness probe failures?"
    Probe might be hitting wrong endpoint. Check: `kubectl describe pod -n platform-api -l app=api | grep -A5 Liveness`. Test endpoint manually: `kubectl port-forward -n platform-api svc/api 8000:8000 && curl http://localhost:8000/health`

???+ question "Pod shows 0/1 ready but no errors in logs?"
    Readiness probe might be failing silently. Verify the probe endpoint returns 200 OK. Update deployment.yaml probe paths if needed.

## Cleanup

```bash
# Delete deployments (keep cluster)
kubectl delete -k gitops/apps/local/

# Delete cluster
./scripts/delete-kind-cluster.sh

# Remove images
docker rmi platform-api:latest platform-web:latest
```

## See Also

- [Layer 0: Local Execution](layer-0-local-execution.md)
- [Layer 1: Docker Images](layer-1-docker-images.md)
- [Layer 2: Docker Compose](layer-2-docker-compose.md)
- [Local Kubernetes Setup](../local-kubernetes.md)
- [Environment Variables Guide](environment-variables-guide.md)
