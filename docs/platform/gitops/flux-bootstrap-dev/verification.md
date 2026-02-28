# Verification & Architecture

Health checks, diagnostic commands, and system design overview.

## Verification Commands

Check Flux health:

```bash
flux check
```

List Flux resources:

```bash
flux get sources git -n flux-system
flux get kustomizations -n flux-system
```

View logs:

```bash
flux logs -n flux-system --follow
```

Check GitRepository status:

```bash
kubectl get gitrepository -n flux-system -o yaml
```

## Architecture

```sh
Main Branch (GitHub)
       ↓
  GitRepository (watches main, 1m interval)
       ↓
git clone → Kustomization (applies gitops/clusters/dev)
       ↓
Flux Controllers (reconcile)
       ↓
gitops-dev Cluster
```

Changes pushed to main branch are automatically applied to the cluster within ~1 minute.

## Why This Approach Works

1. **Unprotected bootstrap:** Flux bootstrap succeeds because it commits to `feat-fluxcd-dev`
2. **Config switch:** Single commit changes where Flux watches (from feat-fluxcd-dev to main)
3. **Protected main:** Main branch protection rules enforce code review (Flux doesn't bypass this)
4. **Transparent workflow:** Everything visible in Git history for audit and rollback

This workflow enables GitOps automation while respecting branch protection policies required for production safety.
