---
name: feature
description: Seven-step gated feature workflow — spec first, plan, implement, test, cleanup, commit with approval at each step
argument-hint: "[feature description]"
allowed-tools: ["Read", "Write", "Edit", "Bash", "Glob", "Grep", "Agent", "AskUserQuestion", "mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__get_registry", "mcp__plugin_roamer_mcp__get_project", "mcp__plugin_roamer_mcp__list_specs", "mcp__plugin_roamer_mcp__get_spec_area", "mcp__plugin_roamer_mcp__get_spec_item", "mcp__plugin_roamer_mcp__log_spec_item", "mcp__plugin_roamer_mcp__log_thread", "mcp__plugin_roamer_mcp__update_project", "mcp__plugin_roamer_mcp__whoami"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/feature.md` to fetch this workflow's current instructions, then follow them exactly from their own first step, including every approval gate they specify. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
