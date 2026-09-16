---
name: orient
description: Start-of-session briefing — read the project registry and open engineering threads, then recommend the top 3 most valuable next steps. Optionally scope to one product or project.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__roamer__read_resource_by_uri", "mcp__roamer__get_registry", "mcp__roamer__get_threads", "mcp__roamer__get_project"]
---

When this Agent Skill is invoked from a client, use the visible user invocation to determine whether text follows the `orient` command.

If the user supplied a product or project name after `orient`:

1. Preserve the complete supplied text as the scope.
2. Use `list_available_resources` to discover the `roamer://prompt/{name}/{scope}.md` resource template.
3. Resolve it as `roamer://prompt/orient/<URL-encoded scope>.md`.
4. Call `read_resource_by_uri` with that resolved URI.

For `/roamer orient roamer MCP`, read `roamer://prompt/orient/roamer%20MCP.md`. Do not read the unscoped `roamer://prompt/orient.md` for a non-empty invocation.

If no text follows `orient`, call `read_resource_by_uri` with `roamer://prompt/orient.md`.

If the client does not expose the invocation argument clearly, ask for the intended scope instead of silently running an unscoped briefing.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
