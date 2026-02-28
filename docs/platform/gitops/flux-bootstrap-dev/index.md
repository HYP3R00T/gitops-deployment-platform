# FluxCD Bootstrap for Dev Cluster

FluxCD (v2.8.1) bootstrapped on gitops-dev EKS cluster with main branch protection workaround.

## Overview

FluxCD enables declarative, continuous GitOps reconciliation. The dev cluster watches the main branch of the gitops-deployment-platform repository and automatically applies changes to infrastructure and deployments.

Bootstrap used a feature branch (`feat-fluxcd-dev`) to work around main branch protection rules, then switched to watching main after merging.

## Pages

- [Bootstrap Procedure](procedure.md) - Step-by-step bootstrap execution
- [Current State](current-state.md) - Active Flux configuration and resources
- [Verification & Architecture](verification.md) - Health checks and system design
