# Commit Message Formatting

**Source**: `commitizen-tools/commitizen` (v4.13.7)

## commitizen

The commitizen hook enforces the Conventional Commits specification, ensuring all commit messages follow a structured format that enables automated tooling and improves project history clarity.

- **Purpose**: Enforces Conventional Commits specification
- **When it runs**: On commit message creation (`commit-msg` stage)
- **What it enforces**:
    - Commit message format: `<type>(<scope>): <description>`
    - Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
    - Proper structure and length constraints
- **Why we use it**:
    - Maintains consistent commit history
    - Enables automated changelog generation
    - Improves code review experience
    - Follows project conventions (see `.github/instructions/commitMessageGeneration.instructions.md`)

## Example Valid Commits

```bash
feat(api): add health check endpoint
fix(bootstrap): correct AWS region default value
docs(env): document GitHub token requirements
chore(deps): update ruff to v0.15.0
refactor(web): simplify API integration logic
test(api): add tests for error handling
```

## Commit Message Structure

### Type

The type indicates the category of change:

- **feat**: New feature or functionality
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, missing semicolons, etc.)
- **refactor**: Code restructuring without changing functionality
- **test**: Adding or modifying tests
- **chore**: Maintenance tasks (dependencies, tooling, etc.)

### Scope (Optional)

The scope indicates which part of the codebase is affected:

- Examples: `api`, `web`, `bootstrap`, `env`, `deps`, `docs`
- Use lowercase
- Keep concise

### Description

The description is a brief summary of the change:

- Start with lowercase
- Use imperative mood ("add" not "added" or "adds")
- No period at the end
- Keep under 72 characters

## Related Documentation

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- Commit Message Guidelines: `.github/instructions/commitMessageGeneration.instructions.md`
