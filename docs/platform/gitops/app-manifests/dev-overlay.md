# Dev Overlay

The dev overlay in `gitops/apps/dev/` customizes base manifests for the dev EKS cluster. This overlay is applied automatically by FluxCD when changes are merged to the main branch.

## Purpose

The dev overlay provides environment-specific customizations that transform base templates into a runnable dev deployment, including:

- Container images from GitHub Container Registry
- Kubernetes namespaces and service discovery
- ConfigMaps for environment variables
- LoadBalancer services for external access

## How It Works

The dev overlay uses Kustomize to reference base deployments and apply patches. Each service directory contains a kustomization.yaml that specifies a base and patches. When FluxCD applies the kustomization, Kustomize combines base and overlay manifests into final Kubernetes resources.

FluxCD reconciles `gitops/apps/dev/` automatically when the repository changes (see [FluxCD Bootstrap](../flux-bootstrap-dev/current-state.md) for reconciliation timing).

## Directory Structure

Each service has a directory containing these files:

- [Namespace](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/namespace.yaml) - Creates namespace
- [Deployment Patch](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/deployment-patch.yaml) - Overrides base image
- [ConfigMap](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/configmap.yaml) - Environment variables and config
- [Service](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/service.yaml) - Exposes deployment
- [Kustomization](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/api/kustomization.yaml) - References base and applies patches

The [root kustomization](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/dev/kustomization.yaml) aggregates api and web overlays.

## Key Concepts

**Image Override Strategy**

The overlay uses `patchesStrategicMerge` to replace base placeholder images with actual container registry images. The `deployment-patch.yaml` file overrides only the image field, keeping changes minimal and focused.

See [Updating Image Tags](updating-image-tags.md) for how to change deployed versions.

**Namespace Convention**

Each service gets its own namespace following the pattern `platform-{service}-dev`:

- api: `platform-api-dev` namespace
- web: `platform-web-dev` namespace

**Service Discovery**

Services reach each other using Kubernetes DNS in the format:

```sh
http://{service-name}.{namespace}.svc.cluster.local:{port}
```

ConfigMaps set environment variables with these FQDNs so services can discover each other at runtime.

**Service Exposure**

Dev services use `LoadBalancer` type to expose deployments externally from the EKS cluster.

## Examples

See [Adding Services](adding-services.md) for complete examples of creating new dev overlays.

## Next Steps

- [Updating Image Tags](updating-image-tags.md) - Deploy new application versions
- [Adding Services](adding-services.md) - Create new service deployments
- [Base Manifests](base-manifests.md) - Understand base templates
