---
name: bug
description: Eight-step gated bug fix workflow — understand before concluding, propose fix, update spec, test, commit with approval at each step
argument-hint: "[bug description]"
allowed-tools: ["Read", "Glob", "Grep", "Agent", "AskUserQuestion", "mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__get_registry", "mcp__plugin_roamer_mcp__get_project", "mcp__plugin_roamer_mcp__get_spec_area", "mcp__plugin_roamer_mcp__get_spec_item", "mcp__plugin_roamer_mcp__log_spec_item", "mcp__plugin_roamer_mcp__update_project", "mcp__plugin_roamer_mcp__resolve_blocker", "mcp__plugin_roamer_mcp__whoami", "mcp__plugin_roamer_mcp__list_specs"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/bug.md` to fetch this workflow's current instructions, then follow them exactly from their own first step, including every approval gate they specify. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
