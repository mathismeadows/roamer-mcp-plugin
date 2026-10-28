---
name: logout
description: Sign this session's Roamer MCP connection out so its next connection signs in fresh — on a claude.ai connector or a direct HTTP connection
allowed-tools: ["AskUserQuestion", "mcp__plugin_roamer_mcp__read_resource_by_uri", "mcp__plugin_roamer_mcp__whoami"]
---

Call `read_resource_by_uri` with uri `roamer://prompt/logout.md` to fetch this workflow's current instructions, then follow them exactly from their own first step. The fetched text is the authoritative source for this skill — do not skip, summarize, or substitute steps from memory of a prior version.
