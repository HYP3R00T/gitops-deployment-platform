# Base Manifests

Base manifests in `gitops/apps/base/` define shared deployment templates for api and web services. These manifests are never applied directly to any cluster. Instead, environment overlays (such as `gitops/apps/dev/`) reference these base templates and customize them.

## Purpose

Base manifests provide:

- Source of truth for shared configuration (health probes, labels, resource limits)
- Templates that all environments inherit from
- Central location to define patterns applied consistently across environments

## How It Works

Each service has a directory in base containing deployment templates. The root `gitops/apps/base/kustomization.yaml` aggregates both services and makes them available for overlays to reference. Overlays never apply base directly. Instead, they use Kustomize to reference base directories and apply environment-specific patches.

## Structure

Each service has a directory in base with these files:

- [Deployment](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/base/api/deployment.yaml) - Container specification with placeholder images
- [Kustomization](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/base/api/kustomization.yaml) - Resource aggregation

The [root kustomization](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/gitops/apps/base/kustomization.yaml) aggregates api and web services.

## Key Concepts

**Placeholder Images**

Base deployments use placeholder images that are replaced by overlays:

- Intent: Never run directly
- Pattern: `registry.example.com/placeholder:placeholder`
- Actual images: Provided by [Dev Overlay](dev-overlay.md)

**Health Probes**

Each service defines a liveness probe matching its endpoint:

- api: `/health` endpoint on port 8000
- web: `/` endpoint on port 4321

Health probes remain consistent across overlays.

**Standard Labels**

All pods include these labels:

- `app: {service}` - Service name (api or web)
- `managed-by: gitops` - Identifies resources managed by gitops
- `environment: dev` - Environment designation (customized by overlays)

**Resource Limits**

Base manifests specify memory and CPU requests and limits. Overlays may refine these per environment.

**Overlay Pattern**

Overlays reference base through Kustomize with:

- `bases:` directive pointing to `../../base/{service}`
- `patchesStrategicMerge:` applying environment-specific changes

Base never changes when updating environment-specific values. Changes always go to overlays.

## See Also

- [Dev Overlay](dev-overlay.md) - How base is customized for dev environment
- [Updating Image Tags](updating-image-tags.md) - How to deploy new versions
- [Adding Services](adding-services.md) - Creating new base and overlay sets
