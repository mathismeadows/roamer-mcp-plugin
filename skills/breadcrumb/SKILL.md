---
name: breadcrumb
description: End-of-session checkpoint — detect merged branches, update spec-item status, and write full session narrative only for still-active work
allowed-tools: ["mcp__roamer__read_resource_by_uri", "mcp__roamer__update_project", "mcp__roamer__log_spec_item", "mcp__roamer__get_project", "mcp__roamer__log_thread"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/breadcrumb.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
