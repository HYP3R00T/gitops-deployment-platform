# Content Mapping Registry

A bidirectional map between code and documentation locations. Use this to know where to document new code or which code to review when updating docs.

## Purpose

- **Adding code?** Find which doc folder/file to update
- **Updating docs?** Find which code folder/files to review
- **Unknown mapping?** Fall back to [Documentation Principles](documentation-principles/index.md)

## Code to Documentation

Where code lives and where it gets documented.

| Code Location | Documentation | Coupling | Notes |
|--------------|---------------|----------|-------|
| [scripts/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/scripts) | [scripts/](../../dev/scripts/index.md) | Strong | One doc per script |
| [services/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/services) | [services/](../../services/api.md) | Strong | Individual service pages |
| [infra/bootstrap/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/bootstrap) | [backend-bootstrap/](../../platform/terraform/backend-bootstrap/index.md) | Strong | Backend setup procedures |
| [gitops/apps/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/apps) | [local-kubernetes.md](../../platform/local-kubernetes.md) | Weak | GitOps architecture overview |
| [local/kubernetes/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/local/kubernetes) | [local-kubernetes.md](../../platform/local-kubernetes.md) | Weak | Kind cluster configuration |
| [.github/workflows/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/.github/workflows) | [ci-cd/](../../platform/ci-cd/index.md) | Strong | Pipeline documentation |
| [mise.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/mise.toml) | [configuration.md](../../dev/mise/configuration.md) | Strong | Tool version config |
| [.pre-commit-config.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.pre-commit-config.yaml) | [pre-commit-hooks/](../../dev/pre-commit-hooks/index.md) | Strong | Hook configuration and usage |
| [docker-compose.yml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/docker-compose.yml) | [docker-compose.md](../../platform/docker-compose.md) | Weak | Local orchestration overview |
| [cliff.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/cliff.toml) | [ci-cd/](../../platform/ci-cd/index.md) | Strong | Changelog generation config |
| [zensical.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/zensical.toml) | [authoring-documentation.md](../../dev/authoring-documentation.md) | Weak | Doc build config |

**Coupling Definitions:**

- **Strong**: Code change requires immediate doc update (configuration, scripts, APIs)
- **Weak**: Doc provides high-level overview; minor code changes do not require doc updates

## Documentation to Code

Which code to check when updating specific docs.

| Documentation | Code to Monitor | What to Check |
|--------------|-----------------|---------------|
| [scripts/](../../dev/scripts/index.md) | [scripts/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/scripts) | Script existence, flags, behavior changes |
| [services/](../../services/api.md) | [services/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/services) | API endpoints, env vars, container ports, dependencies |
| [terraform/](../../platform/terraform/backend-bootstrap/index.md) | [infra/bootstrap/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/bootstrap) | Terraform config, module structure, state files |
| [local-kubernetes.md](../../platform/local-kubernetes.md) | [local/kubernetes/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/local/kubernetes), [gitops/apps/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/gitops/apps) | Kind config, GitOps manifests, cluster scripts |
| [docker-compose.md](../../platform/docker-compose.md) | [docker-compose.yml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/docker-compose.yml) | Service definitions, ports, volumes, networks |
| [ci-cd/](../../platform/ci-cd/index.md) | [.github/workflows/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/.github/workflows), [cliff.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/cliff.toml) | Workflow files, job definitions, release automation |
| [mise/](../../dev/mise/index.md) | [mise.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/mise.toml) | Tool versions, tasks, environment variables |
| [pre-commit-hooks/](../../dev/pre-commit-hooks/index.md) | [.pre-commit-config.yaml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/.pre-commit-config.yaml), [ruff.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/ruff.toml) | Hook configs, linter settings, commit msg validation |
| [authoring-documentation.md](../../dev/authoring-documentation.md) | [zensical.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/zensical.toml) | Doc build config, plugin settings |

## Unmapped Areas

Code and config that exists but lacks clear documentation mapping.

### Intentionally Undocumented

- [requirements.txt](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/requirements.txt) - Python deps managed by pyproject.toml
- [README.md](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/README.md) - Entry point, does not need internal doc
- [.devcontainer/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/.devcontainer) - VS Code container config

### Needs Documentation Decision

- [ty.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/ty.toml) - Purpose unclear; may need docs once usage is established
- [ruff.toml](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/ruff.toml) - Mentioned in pre-commit docs but no dedicated reference
- [infra/modules/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/modules) - Empty folders; document when populated
- [infra/environments/](https://github.com/HYP3R00T/gitops-deployment-platform/tree/main/infra/environments) - Empty folders; document when populated
- Individual kind scripts lack dedicated docs:
    - [create-kind-cluster.sh](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/scripts/create-kind-cluster.sh)
    - [delete-kind-cluster.sh](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/scripts/delete-kind-cluster.sh)
    - [kind-full-workflow.sh](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/scripts/kind-full-workflow.sh)
    - [kind-rebuild-service.sh](https://github.com/HYP3R00T/gitops-deployment-platform/blob/main/scripts/kind-rebuild-service.sh)

## Usage Guidelines

### For AI Assistants

**When user adds or modifies code:**

1. Check Code to Documentation table for mapping
2. If found: Update corresponding documentation
3. If not found: Check if parent folder is mapped
4. If still not found: Follow [Documentation Principles](documentation-principles/index.md) to decide

**When user asks to update docs:**

1. Check Documentation to Code table for what to review
2. Read relevant code files and folders to identify changes
3. Update docs to reflect current state
4. If code reference is missing: Add it to appropriate table above

### For Developers

**Adding new code:**

- Scripts: Create matching doc in [scripts/](../../dev/scripts/index.md)
- Services: Create doc at [services/](../../services/api.md)
- Infrastructure modules: Add to [terraform/](../../platform/terraform/backend-bootstrap/index.md)
- New types of code: Use documentation principles to choose location, then update this registry

**Updating existing code:**

- Check mapping table to find related docs
- Update docs if coupling is Strong
- Consider updating if coupling is Weak and behavior changed significantly

### Maintenance

**When to update this registry:**

- New code folder added (new service, new infra module type)
- Documentation structure changes (promoting file to folder per Principle 3)
- Discovery of unmapped code that should be tracked

**When NOT to update:**

- Individual files added to already-mapped folders (they inherit folder mapping)
- Minor doc reorganization within existing structure
- Temporary or experimental code

## Design Philosophy

This registry uses folder-level mappings to stay flexible and maintainable:

- Maps growing areas like services at folder level, not individual services
- Maps tool configs to doc folders, not individual doc files
- Leaves room for new patterns without rigid constraints
- Complements documentation principles (principles define how to write, registry defines where to write)

## See Also

- [Documentation Principles](documentation-principles/index.md) - How to write docs
- [Authoring Documentation](../dev/authoring-documentation.md) - Practical writing guide
