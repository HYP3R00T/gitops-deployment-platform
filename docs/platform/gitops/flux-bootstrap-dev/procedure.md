# Bootstrap Procedure

Step-by-step execution of FluxCD bootstrap on gitops-dev cluster.

## Pre-Bootstrap Conditions

- EKS cluster `gitops-dev` provisioned in ap-south-1
- Kubernetes manifests staged in `gitops/apps/local/`
- Main branch with protection rules enabled (PR required, no direct commits)
- FluxCD not present in cluster

## Workaround: Bypassing Branch Protection

Main branch has protection rules that prevent direct commits:

- See [branch protection rules](https://github.com/HYP3R00T/gitops-deployment-platform/settings/rules/management) in repository settings

The `flux bootstrap github` command creates manifests and commits them to the target branch. Bootstrapping directly to main would fail with a 403 error.

**Solution:** Bootstrap to unprotected feature branch `feat-fluxcd-dev`, then deploy a commit that switches the monitoring branch to main.

## Execution

### Step 1: Feature Branch Creation

```bash
git checkout -b feat-fluxcd-dev
git push -u origin feat-fluxcd-dev
```

This created an unprotected branch for bootstrap to commit to.

### Step 2: Flux Bootstrap Command

```bash
flux bootstrap github \
  --owner=HYP3R00T \
  --repository=gitops-deployment-platform \
  --branch=feat-fluxcd-dev \
  --path=gitops/clusters/dev \
  --personal
```

**What bootstrap did:**

1. Generated SSH deploy key for repository authentication
2. Created Flux manifests in `gitops/clusters/dev/flux-system/`
3. Committed initial Flux components (gotk-components.yaml, gotk-sync.yaml, kustomization.yaml)
4. Installed Flux controllers in cluster's `flux-system` namespace
5. Set Flux to watch `feat-fluxcd-dev` branch initially

**Commits:** [84ae019](https://github.com/HYP3R00T/gitops-deployment-platform/commit/84ae019) (components) and [52ec2bd](https://github.com/HYP3R00T/gitops-deployment-platform/commit/52ec2bd) (sync manifests)

### Step 3: Branch Modification

File: [gitops/clusters/dev/flux-system/gotk-sync.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/clusters/dev/flux-system/gotk-sync.yaml)

Changed GitRepository spec from:

```yaml
spec:
  ref:
    branch: feat-fluxcd-dev
```

To:

```yaml
spec:
  ref:
    branch: main
```

This prepared the cluster to watch main branch after merge.

**Commit:** [aaa0c45](https://github.com/HYP3R00T/gitops-deployment-platform/commit/aaa0c45)

### Step 4: Merge to Main

All commits from `feat-fluxcd-dev` merged to main. Flux detected the gotk-sync.yaml change and updated its GitRepository CR.

### Step 5: Flux Reconciliation

After merge, Flux automatically:

1. Read updated gotk-sync.yaml from main branch
2. Updated its GitRepository to watch main
3. Began continuous reconciliation from main

## Manifest Files

Bootstrap generated three files in [gitops/clusters/dev/flux-system/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/clusters/dev/flux-system):

- **[gotk-components.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/clusters/dev/flux-system/gotk-components.yaml)** - Flux controller manifests (source, kustomize, helm, notification controllers)
- **[gotk-sync.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/clusters/dev/flux-system/gotk-sync.yaml)** - GitRepository and Kustomization CRs (modified for main branch)
- **[kustomization.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/clusters/dev/flux-system/kustomization.yaml)** - Kustomize aggregation
