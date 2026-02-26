# Documentation Standards & Principles

This project follows six strict principles to prevent "documentation rot" and keep docs a trustworthy source of truth.

## Principle 1: Docs describe what exists (The "No Fiction" Rule)

Document only the current state of `main`. Never document planned or in-progress features.

???+ note "Live documentation"
    Code changes and docs ship together in every PR.

### Core Rules

- Keep facts in `docs/`. Speculation, roadmaps, and ideas belong in external notes (Obsidian/tickets).
- Do not write docs for a feature until the feature PR is ready to merge.
- Update docs whenever code changes in the same PR.

## Principle 2: One document, one purpose (Single Responsibility)

Each document answers one question and addresses one audience. If your title needs "and", split it.

Small, focused files are easier to search, link, read, maintain, and deprecate.

### Signs Your Document Needs Splitting

- Title contains "and" (example: "Deployment and Monitoring")
- Document covers multiple audiences or use cases
- File feels overwhelming to read in one sitting
- Logical sections could stand alone as separate topics

### Example

Bad: `DevOps-Guide.md` (too broad, many audience types)

Good: `how-to-deploy.md`, `how-to-rollback.md`, `monitoring-architecture.md` (each focused, each useful)

## Principle 3: Docs scale by folders, not file length

When a file exceeds 3-4 logical sections, promote it to a folder. This allows independent evolution without merge conflicts.

### When to Promote a File to a Folder

- File has more than 3-4 distinct logical sections
- File requires a Table of Contents to navigate
- Multiple parts could evolve at different rates

### Example Transformation

`gitops.md` becomes too long.

Create folder `gitops/` with focused documents:

- `overview.md` - High-level introduction
- `reconciliation.md` - Reconciliation process
- `secrets.md` - Secret management
- `index.md` - Navigation hub

## Principle 4: Link to code properly (The "Source of Truth" Rule)

Never duplicate large code blocks. Link to the source instead. Code changes frequently; docs don't. Linking ensures accuracy.

### Linking to Documentation Files

Use relative paths within the `docs/` folder.

**DO:**

- `[Other Guide](../other-guide.md)` - links to sibling folder
- `[Authoring Guide](../../dev/authoring-documentation.md)` - links across folders

**DON'T:**

- Relative paths to code outside docs: `[file.py](../../services/api/file.py)`
- Broken anchor attempts to non-doc files

### Linking to Code and Non-Documentation Files

Use full GitHub permalinks. Static documentation sites cannot resolve relative paths outside `docs/`.

**DO:**

- `https://github.com/owner/repo/blob/main/services/api/routes.py` - Current main branch
- `https://github.com/owner/repo/blob/a1b2c3d/scripts/setup.sh` - Specific commit SHA (preserves context)

**DON'T:**

- Relative paths: `[setup.sh](../../scripts/setup.sh)`
- Links without protocol or host: `blob/main/file.py`

Permalinks work everywhere and preserve version context with commit SHAs.

### Referencing Git History and Decisions

When writing "Thinking" or "Journey" docs, link to specific commit SHAs.

**DON'T:**

- "We changed replicas to 3 to handle load" (no verification, no context)

**DO:**

- "In [commit a1b2c3d](https://github.com/owner/repo/commit/a1b2c3d), we increased replicas to 3 to handle peak traffic"

Commit links let readers see the exact code change and timestamp.

## Principle 5: Format, style, and consistency (Professional Presentation)

Avoid patterns that undermine readability or signal poor authorship. These standards keep documentation clean and professional.

### Em-dashes

Hyphens and parentheses are clearer than em-dashes.

**DON'T:**

- "Configuration—provided in the setup file—is required"

**DO:**

- "Configuration (provided in the setup file) is required"
- "Configuration - provided in the setup file - is required"

### Directional Arrows and Symbols

Use prose and lists instead of arrows or complex symbols.

**DON'T:**

- "Step 1 → Step 2 → Step 3" (in text)
- "Update code → test → commit → push → merge" (shows poor readability)

**DO:**

- "Complete Step 1, then Step 2, then Step 3"
- Use numbered lists for sequences
- Link to related docs instead of showing flow as ASCII

### ASCII Art and Box Diagrams

Plain prose and numbered lists are clearer and maintainable.

**DON'T:**

- Box drawings or ASCII flow diagrams

**DO:**

- Prose descriptions: "The system starts with configuration, validates it, then deploys."
- Numbered lists:
  1. Validate configuration
  2. Deploy infrastructure
  3. Run health checks

### Emojis in Code Blocks

Code blocks must be copy-paste safe and readable in terminals.

**DON'T:**

```text
✅ kubectl get pods
❌ kubectl delete pods
```

**DO:**

```shell
kubectl get pods
kubectl delete pods
```

### Unicode Escape Sequences in Prose

Escape sequences appear as literal text in many systems and aren't accessible.

**DON'T:**

- Use "\u274c" or "\u2705" in documentation text

**DO:**

- Use plain text labels: "(DO)", "(DON'T)", "(GOOD)", "(AVOID)"
- Actual Unicode characters sparingly and only when necessary

### Code Block Language Specifiers

All code blocks require language tags for syntax highlighting and clarity.

**DON'T:**

```text
kubectl apply -f deployment.yaml
```

**DO:**

```shell
kubectl apply -f deployment.yaml
```

Always specify the language after the triple backticks: `shell`, `yaml`, `python`, `text`, `json`, `markdown`, etc.

## Principle 6: Documentation structure uniformity (Scalable Hierarchy)

Consistency in structure helps readers navigate confidently and maintainers scale without confusion.

### File Naming

Use lowercase with hyphens only (kebab-case).

**DO:**

- `layer-1-docker.md`
- `bump-api.md`
- `environment-variables.md`

**DON'T:**

- `Layer1Docker.md`
- `BumpApi.md`
- `Environment_Variables.md`

Consistent casing ensures URLs and file systems behave predictably across operating systems.

### Folder Structure

**Every folder with 2+ docs needs an `index.md`** as navigation hub. Single-document folders should flatten to the parent directory.

**index.md should:**

- List all documents in the folder with one-line descriptions
- Be the entry point for readers discovering the folder
- Use consistent naming (`index.md`, not `README.md`)

**Single-doc folders:** Place `topic.md` in parent instead of `topic/index.md`.

### Document Structure

**Every document must:**

- Start with `# Title` matching the navigation label in `zensical.toml`
- Begin with a sentence establishing context and relationship to the system
- Use standard sections in this order:
  1. **Purpose / Overview** - What does this do? Why does it exist?
  2. **How It Works** - Mechanism, flow, or architecture
  3. **Steps / Configuration** - Walkthrough, setup, or usage
  4. **Key Concepts** - Definitions, terminology, important notes
  5. **Examples** (optional) - Code samples or concrete walkthroughs
  6. **Permissions / Requirements** - What's needed
  7. **Next Steps / Related Documents** - Where to go next

Link to nearby related documents to prevent orphaned pages.

### Documentation Domains

Categorize new docs into one of these domains:

**Developer Experience** (`docs/dev/`)

- Tools, local setup, branching workflows, development guides

**Platform & Infrastructure** (`docs/platform/`)

- Cloud architecture, CI/CD pipelines, GitOps machinery, deployment workflows

**Service Specifications** (`docs/services/`)

- Service workloads, endpoints, API contracts, deployment specifications

**Thinking & Journey** (`docs/thinking/`)

- Narratives, decision records (ADRs), post-mortems, architectural decisions

If a document spans multiple domains, place it where **primary ownership** lies or split it per Principle 2.

## See Also

- [Authoring Documentation](../dev/authoring-documentation.md) - Practical guide to writing documentation with Markdown and admonitions
- [Developer Setup](../dev/developer-setup.md) - Getting started with the development environment
- [Pre-commit Hooks](../dev/pre-commit-hooks/index.md) - Automated quality checks for documentation
