---
name: thread-scrub
description: Guided review and disposition of the open-thread backlog — walks threads in priority/staleness order and helps decide what to do with each one. On-demand only, never run automatically as part of another workflow.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__get_threads", "mcp__plugin_roamer_mcp__get_thread", "mcp__plugin_roamer_mcp__log_thread", "mcp__plugin_roamer_mcp__whoami", "mcp__plugin_roamer_mcp__log_blocker"]
---

If text follows the `thread-scrub` command, that text is the scope: call `read_resource_by_uri` with `roamer://prompt/thread-scrub/<the text, URL-encoded>.md` — for example `roamer://prompt/thread-scrub/Acme%20Widgets.md` — and the server fills the scope into the workflow. If nothing follows the command, call `read_resource_by_uri` with `roamer://prompt/thread-scrub.md`. If you can't tell whether text was supplied, ask for the scope rather than running an unscoped review.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
