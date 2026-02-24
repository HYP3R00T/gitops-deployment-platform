# Authoring Documentation

Write effective documentation using Markdown and Zensical features. Follow [Documentation Principles](../thinking/documentation-principles.md) for consistency.

## Markdown Essentials

**File structure:**

- One H1 per file (page title)
- H2 for sections, H3 for subsections (don't go deeper)
- Fenced code blocks with language identifiers

**Links & References:**

| Type | Format | Use When |
|------|--------|----------|
| Internal docs | `[Link Text](path/file.md)` | Linking to other docs |
| Source code | `` `services/api/src/routes.py` `` | Referencing code in passing |
| External | `[Link Text](https://url.com)` | Third-party resources |

For complete Markdown syntax, see [Zensical Reference](https://zensical.org/docs/authoring/markdown/).

## Admonitions (Callouts)

Use `???+` for collapsible blocks (expanded by default):

```markdown
???+ note "Optional Title"
    Block content here.
```

**Core types**: `note`, `tip`, `info`, `warning`, `danger`, `question`, `success`

**When to use:**

- ✅ Prerequisites, warnings, best practices, status labels
- ❌ Regular content, minor points, replacing structure

Example:

```markdown
???+ warning "Destructive Action"
    This will delete data permanently.
```

For advanced admonitions, see [Zensical Guide](https://zensical.org/docs/authoring/admonitions/).

## Tables

Use for structured data. Keep simple (3-5 columns ideal):

```markdown
| Column A | Column B | Column C |
|----------|----------|----------|
| Data 1   | Data 2   | Data 3   |
```

## Style Guidelines

| Guideline | ✅ Good | ❌ Avoid |
|-----------|---------|---------|
| **Voice** | Direct, active: "Run this command" | Passive: "Command should be run" |
| **Clarity** | Define acronyms: "GitOps (Git-based Operations)" | Use undefined abbreviations |
| **Code examples** | Show context: `cd services/api && uv sync` | Isolated commands without setup |
| **Consistency** | Use same terms throughout | Mix terminology |

## Before Committing

```bash
mise run docs
```

Verify:

- Broken links
- Formatting correct
- Code blocks render
- Admonitions display
- Tables aligned
- Follows documentation principles
- Matches current code (no fiction)

## See Also

- [Documentation Principles](../thinking/documentation-principles.md) - Core standards
- [Zensical Markdown](https://zensical.org/docs/authoring/markdown/) - Full syntax reference
- [Zensical Admonitions](https://zensical.org/docs/authoring/admonitions/) - Advanced callouts
