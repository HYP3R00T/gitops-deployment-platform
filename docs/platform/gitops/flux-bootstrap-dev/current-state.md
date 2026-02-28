# Current State

Active Flux configuration and running controllers on gitops-dev cluster.

## Flux System Pods

All controllers running in `flux-system` namespace:

```sh
helm-controller-5f7f9d4df8-vvpd6           1/1     Running
kustomize-controller-6474954f6d-zx8sz      1/1     Running
notification-controller-6b948f7c8d-z4mc9   1/1     Running
source-controller-5485db8447-l75sm         1/1     Running
```

## GitRepository Configuration

[gotk-sync.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/clusters/dev/flux-system/gotk-sync.yaml#L8-L12) currently configured:

```yaml
spec:
  interval: 1m0s
  ref:
    branch: main
  secretRef:
    name: flux-system
  url: ssh://git@github.com/HYP3R00T/gitops-deployment-platform
```

**Configuration details:**

- **Source:** GitHub repository (HTTPS mirror of main branch)
- **Auth:** SSH deploy key (read-only)
- **Branch:** main
- **Interval:** 1 minute (fast feedback for development)

## Kustomization Configuration

Same file defines root Kustomization:

```yaml
spec:
  interval: 10m0s
  path: ./gitops/clusters/dev
  prune: true
  sourceRef:
    kind: GitRepository
    name: flux-system
```

**Configuration details:**

- **Watch:** `gitops/clusters/dev/` directory in repository
- **Prune:** Enabled (removes resources deleted from Git)
- **Interval:** 10 minutes

## App Kustomization Target

The cluster-level [apps.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/clusters/dev/apps.yaml) Kustomization points to:

- **Path:** `./gitops/apps/dev`
- **Source:** `GitRepository/flux-system`
- **Prune:** Enabled

This applies service manifests for API and web from the dev overlay, including their dedicated namespaces.

## Deploy Key

SSH deploy key created by bootstrap:

- **Name:** flux (readonly) or similar in Flux UI
- **Permissions:** Read-only access to repository
- **Repository:** gitops-deployment-platform
- **Location:** [GitHub repository deploy keys](https://github.com/HYP3R00T/gitops-deployment-platform/settings/keys)
