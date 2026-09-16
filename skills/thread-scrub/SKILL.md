---
name: thread-scrub
description: Guided review and disposition of the open-thread backlog — walks threads in priority/staleness order and helps decide what to do with each one. On-demand only, never run automatically as part of another workflow.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__roamer__read_resource_by_uri", "mcp__roamer__get_threads", "mcp__roamer__get_thread", "mcp__roamer__log_thread"]
---

When this Agent Skill is invoked from a client, use the visible user invocation to determine whether text follows the `thread-scrub` command.

If the user supplied a product or project name after `thread-scrub`:

1. Preserve the complete supplied text as the scope.
2. Use `list_available_resources` to discover the `roamer://prompt/{name}/{scope}.md` resource template.
3. Resolve it as `roamer://prompt/thread-scrub/<URL-encoded scope>.md`.
4. Call `read_resource_by_uri` with that resolved URI.

For `/roamer thread-scrub roamer MCP`, read `roamer://prompt/thread-scrub/roamer%20MCP.md`. Do not read the unscoped `roamer://prompt/thread-scrub.md` for a non-empty invocation.

If no text follows `thread-scrub`, call `read_resource_by_uri` with `roamer://prompt/thread-scrub.md`.

If the client does not expose the invocation argument clearly, ask for the intended scope instead of silently running an unscoped review.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
