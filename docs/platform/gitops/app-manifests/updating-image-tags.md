# Updating Image Tags

When a new version of api or web is released and published to the container registry, the dev deployment must be updated to use the new image. This is a manual process that requires a pull request.

## Purpose

Updating image tags answers:

- How do I deploy a new application version?
- Why isn't deployment automatic?
- What files do I need to modify?

## How It Works

FluxCD watches the Git repository for changes, not the container registry. When a new image is published to the GitHub Container Registry (GHCR), FluxCD does not automatically detect or deploy it. A developer must manually update the manifest and commit the change to Git. When the pull request is merged, FluxCD detects the change and reconciles the cluster to the new state.

## Steps

### Step 1: New Release Published

The CI/CD pipeline builds and publishes a new image to GitHub Container Registry (GHCR) when a release is created. The image is tagged with the service version:

- API: `ghcr.io/hyp3r00t/api:0.1.2`
- Web: `ghcr.io/hyp3r00t/web:0.0.3`

### Step 2: Create Pull Request

Create a pull request that updates [deployment-patch.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/deployment-patch.yaml) for the service.

For the api service:

1. Edit `gitops/apps/dev/api/deployment-patch.yaml`
2. Update the image field to the new version
3. Commit with a descriptive message: "deploy: api v0.1.2 to dev"
4. Push and create a pull request

### Step 3: Merge and FluxCD Deployment

When the pull request is merged:

1. The updated `deployment-patch.yaml` is committed to main
2. FluxCD detects the repository change (GitRepository reconciles every 1 minute)
3. FluxCD re-applies the kustomization (every 10 minutes)
4. The new image is pulled and the pod is restarted with the updated deployment

## Key Concepts

**Which Files to Edit**

Only the `deployment-patch.yaml` file is updated:

- `gitops/apps/dev/{service}/deployment-patch.yaml` - Update the image tag here
- `gitops/apps/dev/{service}/namespace.yaml` - No changes
- `gitops/apps/dev/{service}/service.yaml` - No changes
- `gitops/apps/dev/{service}/configmap.yaml` - No changes

**FluxCD Reconciliation Timing**

FluxCD watches Git through multiple components (see [FluxCD Bootstrap](../flux-bootstrap-dev/current-state.md)):

- **GitRepository**: Polls main branch every 1 minute
- **Root Kustomization**: Applies every 10 minutes
- **App Kustomization**: Applies with pruning enabled

Deployment typically completes within 11 minutes of merge.

**Why Manual PRs**

Container registries and Git repositories are separate systems. FluxCD pulls from Git, not from the registry. Without a Git commit, there is nothing for FluxCD to detect. Automated image tag updates would require pushing commits to Git automatically (not currently implemented).

## Examples

**Updating API to version 0.1.2**

Edit `gitops/apps/dev/api/deployment-patch.yaml` and update the image:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
spec:
  template:
    spec:
      containers:
      - name: api
        image: ghcr.io/hyp3r00t/api:0.1.2
```

**Updating Web to version 0.0.5**

Edit `gitops/apps/dev/web/deployment-patch.yaml` and update the image:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  template:
    spec:
      containers:
      - name: web
        image: ghcr.io/hyp3r00t/web:0.0.5
```

## Next Steps

- [Dev Overlay](dev-overlay.md) - Understand the kustomization structure
- [Adding Services](adding-services.md) - Create new services with deployment-patch.yaml
- [FluxCD Bootstrap](../flux-bootstrap-dev/index.md) - How reconciliation works
