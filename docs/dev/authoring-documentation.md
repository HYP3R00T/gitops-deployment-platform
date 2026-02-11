# Authoring Documentation

This guide explains how to write effective documentation for this project using Markdown and Zensical-specific features.

## Markdown Basics

Documentation files use standard Markdown syntax with Zensical enhancements. For comprehensive Markdown guidance, see the [Zensical Markdown Reference](https://zensical.org/docs/authoring/markdown/).

### File Structure

```markdown
# Page Title (H1 - only one per file)

Brief introduction explaining the page's purpose.

## Section (H2)

Content organized into logical sections.

### Subsection (H3)

More specific content within sections.
```

**Guidelines:**

- One H1 per file (page title)
- Use H2 for main sections, H3 for subsections
- Avoid going deeper than H3
- Use fenced code blocks with language identifiers (python, bash, toml, yaml, etc.)
- See full syntax at [Zensical Markdown Reference](https://zensical.org/docs/authoring/markdown/)

### Links

**Internal documentation links:**

```markdown
[Developer Setup](developer-setup.md)
[Mise Configuration](mise/index.md)
```

**Source code references** (use inline code style):

```markdown
See the configuration in `mise.toml` at the repository root.
The API routes are defined in `services/api/src/api/routes.py`.
```

**External links:**

```markdown
[Mise Documentation](https://mise.jdx.dev/)
```

## Admonitions (Callouts)

Admonitions are styled blocks that highlight important information.

### Default Format

**Use `???+` by default** - this creates collapsible blocks that are expanded by default:

```markdown
???+ note
    This is a collapsible note that's expanded by default.
    Users can collapse it if they want.
```

### Available Types

Choose the type that best conveys semantic meaning:

- **note** - General information, explanations, or context
- **tip** - Best practices, recommendations, helpful hints
- **info** - Status updates, version information, contextual details
- **warning** - Actions that could cause problems if not done carefully
- **danger** - Destructive actions or serious security concerns
- **example** - Example usage or implementation patterns
- **abstract**, **success**, **question**, **failure**, **bug**, **quote** - Additional types as needed

### Custom Titles

```markdown
???+ warning "Prerequisites"
    Ensure AWS CLI is configured before running this command.
```

### When to Use Admonitions

**✅ Good for:**

- Status indicators (In Development, Deprecated)
- Prerequisites and requirements
- Security warnings
- Best practices
- Optional/advanced configuration

**❌ Avoid for:**

- Regular content (use normal paragraphs)
- Every minor point (dilutes impact)
- Replacing proper document structure

**For complete admonition documentation**, including nested blocks, inline placement, and all formatting options, see the [Zensical Admonitions Guide](https://zensical.org/docs/authoring/admonitions/).

## Tables

Use tables for structured data:

```markdown
| Tool       | Version | Purpose               |
| ---------- | ------- | --------------------- |
| python     | 3.14    | API runtime           |
| node       | 22.22.0 | Web frontend runtime  |
| terraform  | latest  | Infrastructure as Code|
```

Keep tables simple (3-5 columns ideal) and use consistent formatting.

## Documentation Principles

Follow the project's [Documentation Principles](../thinking/documentation-principles.md):

1. **No Fiction Rule** - Only document what exists now, mark aspirational features clearly
2. **Single Responsibility** - One topic per file, focused and cohesive
3. **Folder Scaling** - Files over 200 lines with 3-4+ sections become folders
4. **Source of Truth** - Link to source code properly, no relative paths from docs to code

## Style Guidelines

### Tone and Voice

- **Be direct and clear** - Avoid unnecessary words
- **Use active voice** - "Run this command" not "This command should be run"
- **Define acronyms** - First use: "GitOps (Git-based Operations)"
- **Be consistent** - Use the same terms throughout

### Command Examples

Always show the expected command with context:

```bash
# From the repository root
cd services/api
uv sync
uv run pytest
```

### File References

**Do:**

```markdown
The configuration is defined in `mise.toml`.
Check the routes in `services/api/src/api/routes.py`.
```

**Don't:**

```markdown
The configuration is [here](../../mise.toml).
Check [routes.py](../../services/api/src/api/routes.py).
```

## Testing Documentation

Before committing documentation changes:

1. **Preview locally:**

   ```bash
   mise run docs
   ```

2. **Check for:**
   - Broken links
   - Formatting issues
   - Code block rendering
   - Admonition display
   - Table alignment

3. **Verify compliance:**
   - Follows documentation principles
   - Matches actual code/config
   - No fiction or aspirational claims (unless marked)

## Resources

- [Zensical Markdown Reference](https://zensical.org/docs/authoring/markdown/) - Complete Markdown syntax guide
- [Zensical Admonitions Guide](https://zensical.org/docs/authoring/admonitions/) - Detailed admonition documentation
- [Documentation Principles](../thinking/documentation-principles.md) - Project-specific documentation standards
- [Python-Markdown Extensions](https://facelessuser.github.io/pymdown-extensions/) - Technical reference
