---
name: thread-scrub
description: Guided review and disposition of the open-thread backlog — walks threads in priority/staleness order and helps decide what to do with each one. On-demand only, never run automatically as part of another workflow.
argument-hint: "[optional: product or project name]"
allowed-tools: ["mcp__roamer__read_resource_by_uri", "mcp__roamer__get_threads", "mcp__roamer__get_thread", "mcp__roamer__log_thread"]
---

If a product or project name was given as an argument, call `read_resource_by_uri` with uri `roamer://prompt/thread-scrub/<that name>.md` (URL-encode the name if it contains spaces or special characters). Otherwise call `read_resource_by_uri` with uri `roamer://prompt/thread-scrub.md`.

Then follow the fetched text exactly from its own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
