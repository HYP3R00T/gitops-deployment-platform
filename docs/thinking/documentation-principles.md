# Documentation Standards & Principles

To ensure documentation remains accurate, scalable, and maintainable, this project adheres to four strict principles. These guardrails prevent "documentation rot" and ensure the docs remain a trustworthy source of truth alongside the code.

## Principle 1: Docs describe *what exists* (The "No Fiction" Rule)

Documentation must reflect the current state of the `main` branch. It is strictly forbidden to document features, architectures, or workflows that are "planned" or "in progress" within the repository documentation.

- **Why:** If documentation describes a system that doesn't exist yet, it erodes trust. A reader following a guide that fails because the code isn't there yet will stop reading.
- **The Boundary:**
- **In-Repo Docs (`docs/`)**: Only facts. The "As-Is" state.
- **External Notes (Obsidian/Tickets)**: Speculation, roadmaps, drafts, and the "To-Be" state.

- **Workflow:** Do not write the documentation for a feature until the feature PR is ready to merge. Code and docs ship together.

## Principle 2: One document, one purpose (Single Responsibility Principle)

Apply the Single Responsibility Principle (SRP) to writing. A document should answer one specific question or address one specific audience.

- **The Smell Test:** If you have to use "and" in the document title (e.g., "Deployment **and** Monitoring Guide"), it likely needs to be split.
- **Why:** Large, multi-purpose files are hard to search, hard to link to, and intimidating to read. Small, focused files are easy to maintain and deprecate.
- **Example:**
- ❌ `DevOps-Guide.md` (Too broad)
- ✅ `how-to-deploy.md`, `how-to-rollback.md`, `monitoring-architecture.md` (Focused)

## Principle 3: Docs scale by *folders*, not file length

We resist the urge to create "Mega-Readme" files. When a topic becomes complex, we do not make the file longer; we promote it to a directory.

- **The Rule of Thumb:** If a markdown file exceeds ~3-4 distinct logical sections or requires a Table of Contents to navigate, it should likely become a folder.
- **The Transformation:**

1. `gitops.md` becomes too long.
2. Create folder `gitops/`.
3. Break content into `gitops/overview.md`, `gitops/reconciliation.md`, `gitops/secrets.md`.
4. Create `gitops/index.md` (or `README.md`) as the map for that folder.

- **Why:** This mirrors code modularity. It allows different parts of a system to evolve at different speeds without causing merge conflicts in a massive monolithic document.

## Principle 4: Thinking docs reference commits (The "Source of Truth" Rule)

Documentation explains the *Why* and the *Context*. The Code explains the *How*. We do not duplicate code into documentation unless it is a small, immutable snippet for illustration.

- **The Practice:** Instead of copy-pasting a 50-line YAML file into a markdown block (which will go stale immediately), use a permalink to the specific file or commit hash on GitHub.
- **Referring to History:** When writing "Thinking" or "Journey" docs (in the `thinking/` folder), link to the **specific commit SHA** that introduced the change or failure.
- ❌ "We changed the `replicas` count to 3." (Vague)
- ✅ "In commit `a1b2c3d`, we increased `replicas` to 3 to handle load." (Verifiable)

- **Why:** Code changes frequently. Docs change slowly. By linking to code rather than duplicating it, we ensure the documentation never presents "dead" code as the truth.

### Implementation Note

When writing docs, categorize them mentally into one of our four domains:

1. **Developer Experience** (`docs/dev/`)
    - *Context:* Tools, local setup, and branching workflows.
2. **Platform & Infrastructure** (`docs/platform/`)
    - *Context:* Cloud architecture, GitOps machinery, and CI pipelines.
3. **Service Specifications** (`docs/services/`)
    - *Context:* Workload definitions, endpoints, and build contracts.
4. **Thinking & Journey** (`docs/thinking/`)
    - *Context:* Narratives, decisions (ADRs), and post-mortems.

*If a document tries to bridge multiple domains (e.g., explaining how a Service interacts with the Platform), place it where the **primary ownership** lies, or apply Principle #2 and split it.*
