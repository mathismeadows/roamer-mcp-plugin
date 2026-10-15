---
name: release-notes
description: Draft release notes for a product, project, or the whole workspace over a date window — Internal and External sections, review-only, never sends anything.
argument-hint: "[optional: product or project name] [optional: YYYY-MM-DD to YYYY-MM-DD]"
allowed-tools: ["mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__get_status_transitions", "mcp__plugin_roamer_mcp__get_spec_item", "mcp__plugin_roamer_mcp__get_project", "mcp__plugin_roamer_mcp__get_threads"]
---

Text after the `release-notes` command can give a scope (a product or project name), a date window (for example `2026-10-01 to 2026-10-14`), or both. Call `read_resource_by_uri` with `roamer://prompt/release-notes.md`, adding whichever were given as URL-encoded query parameters, scope first — for example `roamer://prompt/release-notes.md?scope=Acme%20Widgets&window=2026-10-01%20to%202026-10-14`, or `roamer://prompt/release-notes.md?window=2026-10-01%20to%202026-10-14` for a window alone. With nothing after the command, read `roamer://prompt/release-notes.md` as it is. If you can't tell which part is the scope and which the window, ask rather than guessing.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
