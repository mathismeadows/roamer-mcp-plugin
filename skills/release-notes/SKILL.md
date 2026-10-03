---
name: release-notes
description: Draft release notes for a product, project, or the whole workspace over a date window — Internal and External sections, review-only, never sends anything.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__roamer__read_resource_by_uri", "mcp__roamer__get_status_transitions", "mcp__roamer__get_spec_item", "mcp__roamer__get_project", "mcp__roamer__get_threads", "mcp__roamer__get_thread"]
---

When this Agent Skill is invoked from a client, use the visible user invocation to determine whether text follows the `release-notes` command.

If the user supplied a product or project name after `release-notes`:

1. Preserve the complete supplied text as the scope.
2. Use `list_available_resources` to discover the `roamer://prompt/{name}/{scope}.md` resource template.
3. Resolve it as `roamer://prompt/release-notes/<URL-encoded scope>.md`.
4. Call `read_resource_by_uri` with that resolved URI.

For `/roamer release-notes roamer MCP`, read `roamer://prompt/release-notes/roamer%20MCP.md`. Do not read the unscoped `roamer://prompt/release-notes.md` for a non-empty invocation.

If no text follows `release-notes`, call `read_resource_by_uri` with `roamer://prompt/release-notes.md`.

If the client does not expose the invocation argument clearly, ask for the intended scope instead of silently running an unscoped draft.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
