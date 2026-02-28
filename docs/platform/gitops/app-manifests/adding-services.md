# Adding Services

To add a new application service to the gitops deployment, create manifests in both base and dev overlay directories following the established patterns.

## Purpose

Adding services answers:

- How do I deploy a new application?
- What files and directories do I create?
- What naming conventions must I follow?

## How It Works

Services are deployed using a base plus overlay pattern. First, create shared base deployment templates. Then, create environment-specific overlays that reference the base and apply customizations. Each service gets its own namespace and ConfigMap for configuration.

## Steps

### Step 1: Create Base Manifests

Create a new directory under `gitops/apps/base/` for your service.

Create [deployment.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/base/api/deployment.yaml) with placeholder images and standard labels:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {service}
  labels:
    app: {service}
    managed-by: gitops
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {service}
  template:
    metadata:
      labels:
        app: {service}
        managed-by: gitops
        environment: dev
    spec:
      containers:
      - name: {service}
        image: registry.example.com/placeholder:placeholder
        ports:
        - containerPort: {port}
        livenessProbe:
          httpGet:
            path: {health-endpoint}
            port: {port}
          initialDelaySeconds: 30
          periodSeconds: 10
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "500m"
```

Create [kustomization.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/base/api/kustomization.yaml) referencing the deployment:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
```

Update [gitops/apps/base/kustomization.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/base/kustomization.yaml) to include the new service:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - api
  - web
  - {service}
```

### Step 2: Create Dev Overlay

Create a new directory under `gitops/apps/dev/` with environment-specific manifests.

Create [namespace.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/namespace.yaml):

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: platform-{service}-dev
```

Create [deployment-patch.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/deployment-patch.yaml):

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {service}
spec:
  template:
    spec:
      containers:
      - name: {service}
        image: {registry}/{image}:{tag}
```

Create [service.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/service.yaml):

```yaml
apiVersion: v1
kind: Service
metadata:
  name: {service}
  namespace: platform-{service}-dev
spec:
  type: LoadBalancer
  selector:
    app: {service}
  ports:
  - port: 80
    targetPort: {port}
    protocol: TCP
```

Create [configmap.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/configmap.yaml):

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {service}-config
  namespace: platform-{service}-dev
data:
  CONFIG_VALUE: "your-value-here"
```

For services that need to reach other services, use Kubernetes DNS. For example, web reaching api:

```yaml
PUBLIC_API_URL: http://platform-api-dev.platform-api-dev.svc.cluster.local:8000
```

Create [kustomization.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/kustomization.yaml):

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
namespace: platform-{service}-dev
resources:
  - namespace.yaml
  - service.yaml
  - configmap.yaml
bases:
  - ../../base/{service}
patchesStrategicMerge:
  - deployment-patch.yaml
```

Update [gitops/apps/dev/kustomization.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/kustomization.yaml) to include the new service:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - api
  - web
  - {service}
```

### Step 3: Verify Configuration

Test that kustomization builds correctly:

```shell
kustomize build gitops/apps/dev/{service}
```

This should output valid Kubernetes manifests without errors.

### Step 4: Commit and Deploy

1. Commit all new files to a pull request
2. Include the new service description in the PR
3. Merge the pull request
4. FluxCD will automatically apply the new service to the dev cluster

## Key Concepts

**Naming Conventions**

Use lowercase, single-word service names:

- Service name: `api`, `web`, `worker` (not `my-service` or `MyService`)
- Namespace: `platform-{service}-dev` (e.g., `platform-worker-dev`)
- Files: lowercase with hyphens (e.g., `deployment-patch.yaml`)

**Label Requirements**

All resources must include these labels:

```yaml
labels:
  app: {service}
  managed-by: gitops
  environment: dev
```

These labels enable filtering and querying across the platform.

**Service Discovery**

Services can reach each other using Kubernetes DNS:

```sh
http://{service-name}.{namespace}.svc.cluster.local:{port}
```

For example, to reach the api service from web:

```sh
http://api.platform-api-dev.svc.cluster.local:8000
```

Use this format in ConfigMap environment variables.

## Examples

See [Dev Overlay](dev-overlay.md) for complete example files from existing services.

## Next Steps

- [Dev Overlay](dev-overlay.md) - Understand dev customization patterns
- [Updating Image Tags](updating-image-tags.md) - Deploy new versions after creation
- [Base Manifests](base-manifests.md) - Understand base structure
