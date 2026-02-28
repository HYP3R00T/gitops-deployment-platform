# Application Manifests

The `gitops/apps/` directory contains Kubernetes manifests for deployments using a base and overlay pattern. This pattern allows the same application configuration (api, web) to be deployed across different environments with environment-specific customizations.

## Purpose

This documentation explains the base and overlay deployment structure, how to update images, and how to add new services.

## Pages

- [Base Manifests](base-manifests.md) - Shared deployment templates
- [Dev Overlay](dev-overlay.md) - Environment-specific customizations for dev
- [Updating Image Tags](updating-image-tags.md) - How to deploy new application versions
- [Adding Services](adding-services.md) - Creating new application deployments

## See Also

- [FluxCD Bootstrap](../flux-bootstrap-dev/index.md) - How dev cluster applies these manifests
