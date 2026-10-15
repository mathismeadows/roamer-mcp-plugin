---
name: breadcrumb
description: End-of-session checkpoint — detect merged branches, update spec-item status, and write full session narrative only for still-active work
allowed-tools: ["mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__update_project", "mcp__plugin_roamer_mcp__log_spec_item", "mcp__plugin_roamer_mcp__get_project", "mcp__plugin_roamer_mcp__log_thread", "mcp__plugin_roamer_mcp__whoami", "Bash"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/breadcrumb.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
