# GitOps & FluxCD

Declarative cluster state management using FluxCD. This section covers both the cluster bootstrap configuration and application manifest structure.

## Current State

FluxCD is bootstrapped on the gitops-dev EKS cluster. The cluster continuously reconciles its state with declarations in the Git repository.

## Pages

- [App Manifests](app-manifests/index.md) - Application deployment structure and environment overlays
- [Dev Bootstrap](flux-bootstrap-dev/index.md) - How FluxCD was set up on the dev cluster
